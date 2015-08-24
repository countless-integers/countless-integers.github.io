---
layout: post
title:  "Weird case of PHP interface constants"
date:   2015-08-24 14:17:35
categories: php interface constant
---
While trying to mock an object using mockery I came across this:

    Fatal error: Undefined class constant 'self::LIMIT' in /project.path/vendor/mockery/mockery/library/Mockery/Generator/Parameter.php on line 62

So I tried to make the mock with vanilla PHPUnit:

    Fatal error: Undefined class constant 'self::LIMIT' in /project.path/vendor/phpunit/phpunit-mock-objects/src/Framework/MockObject/Generator.php on line 1064

My first guess was that it had a problem with me using constants as default parameter values in method definitions like so:

{% highlight php %}
  public function method($param = self::VALUE)
{% endhighlight %}

However this sounded wrong -- I used that before and never had a problem with it. So I dug deeper. Then I came across an interface that the mocked class implemented. It looked something like this:

{% highlight php %}
    interface ITotallyForgotIMadeAnInterfaceForThis
    {
        public function method($param = self::VALUE);
    }
{% endhighlight %}

I had to look twice, but there it was, my undefined constant. How this had worked (because it did) during normal application run? It shouldn't, but somehow it did? Anyone can elaborate?
