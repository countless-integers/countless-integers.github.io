---
layout: post
title: Chained notifications in Laravel
date: 2020-08-29
published: true
categories: php laravel
---

You have probably heard about notifications in Laravel. If you have a bit more experience with the framework, you are also likely to be familiar with chained jobs. However have you heard about chained notifications? No? Good, because that is not a thing.

## So what is it?  

It is just a mental shortcut I made for using a chained job when queuing notifications for processing. The default behavior of [`Notification::send`](https://github.com/laravel/framework/blob/7965ce0a88e991427eeab9b241919a368e1e6851/src/Illuminate/Notifications/NotificationSender.php#L71) is to go over notification's delivery channels, returned by `via` method in the notification class, and dispatch a job each of those ([source code](https://github.com/laravel/framework/blob/7965ce0a88e991427eeab9b241919a368e1e6851/src/Illuminate/Notifications/NotificationSender.php#L177)). This way the often time-consuming and error prone task of actually sending those messages is detached from whatever flow triggered them (i.e. user's API request). This is great because the initiating flow can terminate faster, any temporary errors triggered during sending notifications or communicating with 3rd parties to whom we delegate that to, can be retried by our queue workers etc. 


## The problem

However, I had to deal with a use case when the default was insufficient. Specifically when one of the channels is a signaling push notification and the other is a database record. The latter needs to exist before the former or UI-generated requests triggered by the push notification will fail trying to access a resource that does not yet exist. You might frown and ask: why not just include all the data in the push notification and forgo that needles round-trip to the API/DB? I will have to conveniently skip the detailed rationale and you will have to trust that in right context, under specific conditions (etc.) that does make sense. The relevant implication of it is that the default implementation in Laravel does not cover that use case.

## A solution

There are two things in Laravel that let us work around this problem:

* dependency injection used in the Notifications component that lets us swap implementations of different parts 
* chained jobs feature in Jobs component that lets an individual job trigger a sequence of other jobs 

Utilizing those we can create our very own `ChainedNotificationSender`, extending Laravel's own [`NotificationSender` class](https://github.com/laravel/framework/blob/7.x/src/Illuminate/Notifications/NotificationSender.php):

```php
<?php
declare(strict_types=1);

namespace App\Notifications;

use Ramsey\Uuid\Uuid;
use Illuminate\Notifications\NotificationSender;
use Illuminate\Notifications\SendQueuedNotifications;

class ChainedNotificationSender extends NotificationSender
{
    /**
     * @inheritDoc
     */
    protected function queueNotification($notifiables, $notification)
    {
        $notifiables = $this->formatNotifiables($notifiables);
        $original = clone $notification;

        foreach ($notifiables as $notifiable) {
            $notificationId = Uuid::uuid4()->toString();

            $channels = (array)$original->via($notifiable);

            if (empty($channels)) {
                continue;
            }
            
            if (!is_null($this->locale)) {
                $notification->locale = $this->locale;
            }

            $queue = $notification->queue;
            if (method_exists($notification, 'viaQueues')) {
                $queue = $notification->viaQueues()[$channel] ?? null;
            }
			
			// This is the point where we stop copy-pasting original framework
			// code and actual start implementing the chained job logic.
			// We define our preferred order here...
            $expectedOrder = [
                'database',
                'broadcast',
            ];
            // ...but still respect what the `via` method actually returns...
            $orderedChannels = array_intersect($expectedOrder, $channels);
			// ...and append any other channels in whatever order
            $extraChannels = array_diff($channels, $expectedOrder);
            $orderedChannels = array_merge($orderedChannels, $extraChannels);

            $commandChain = [];
            foreach ($orderedChannels as $channel) {
                $notification = clone $original;
                $notification->id = $notificationId;
                // we build the job same way as in the parent class:
                $command_chain[] = (new SendQueuedNotifications($notifiable, $notification, [$channel]))
                    ->onConnection($notification->connection)
                    ->onQueue($queue)
                    ->delay($notification->delay)
                    ->through(array_merge(
                        method_exists($notification, 'middleware') ? $notification->middleware() : [],
                        $notification->middleware ?? []
                    ))
            }

            /** @var SendQueuedNotifications $first_command */
            $firstCommand = array_shift($commandChain);
            if (!empty($commandChain)) {
                $firstCommand->chain($commandChain);
            }
            $this->bus->dispatch($firstCommand);
        }
    }
}
```

Now our `ChannelManager` class using it:

```php
<?php
declare(strict_types=1);

namespace App\Notifications;

use Illuminate\Contracts\Events\Dispatcher;
use Illuminate\Contracts\Bus\Dispatcher as Bus;
use Illuminate\Notifications\ChannelManager as IlluminateChannelManager;

class ChannelManager extends IlluminateChannelManager
{
    /**
     * @inheritDoc
     */
    public function sendInOrder($notifiables, $notification)
    {
        return (new ChainedNotificationSender(
            $this,
            $this->container->make(Bus::class),
            $this->container->make(Dispatcher::class),
            $this->locale
        ))->send($notifiables, $notification);
    }
}
```

and have that override the default implementation by registering it in our `AppServiceProvider` (or whatever provider you think is more relevant):

```php
<?php
declare(strict_types=1);

use App\Notifications;
use Illuminate\Support\ServiceProvider;
use Illuminate\Notifications\ChannelManager as IlluminateChannelManager;
// ...

class AppServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(IlluminateChannelManager::class, function ($app) {
            return new ChannelManager($app);
        });
    }
}
```

That is it. From this point onward, we can send our notifications in order by calling our non-standard method `sendInOrder` through the notification facade.

## Testing

Testing in specific flows might be tricky, but we can at least assert that a chained job was issued instead of multiple, separate ones, by swapping the job dispatcher with a fake (` Illuminate\Support\Facades\Buss::fake`) and then checking what was queued (`Illuminate\Support\Testing\Fakes\BusFake::assertDispatched`).

## Conclusion 

It feels a bit hacky as we have to overwrite two framework classes to make it happen, but at the same time the framework is flexible enough not get in the way when a custom solution like this is needed. Of course, should you decide to deploy such implementations in your own codebase, you have to be mindful that any future framework update can potentially break your app. Caveat emptor.