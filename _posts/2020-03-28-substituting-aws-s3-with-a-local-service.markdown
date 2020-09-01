---
layout: post
title: Substituting AWS S3 with a local service
date: 2020-03-28
published: true
categories: development
tags: aws laravel
---

S3 is rather cheap and you might wander why bother, but there are multiple good reasons to use a local substitute during development. Among them:

* working offline, e.g. on a plane  
* marginally lower latency
* no risk of bucket name collisions, especially when you create them like crazy during tests
* no fuss with credentials
* tear it apart all you want
* check those pesky edge cases with connectivity errors

For context, I'll mention upfront that this solution was tested on a PHP project written in Laravel, but should be equally applicable for any other technology.

## What's available 

Some solutions we've tried out:

* [MinIO](https://min.io/) -- a storage service in its own right, but maintaining a (mostly) S3-compatible API. Has its own set of tools and a GUI.
* [S3Mock from Adobe](https://github.com/adobe/S3Mock) -- focused on API compatibility, no frills. Written in Java.
* [Fake S3](https://github.com/jubos/fake-s3) -- similar to S3Mock (it's even referenced in their GH page). Written in Ruby. 

## Implementation

Out of those, we've ended up using MinIO. It was mostly because of convenience as we were already using [Homestead](https://laravel.com/docs/master/homestead) Vagrant box for development and it came as an installation option with it. It was also important for me to have some tools to inspect all buckets during manual tests and since none of those solutions worked correctly with AWS Cli tool for me, MinIO came through with its GUI and Cli tool (somewhat confusingly called `mc` aka *Not Midnight Commander*). 

Not to say that, e.g. S3Mock, was difficult to set up. My collegue came up with the painless solution of using the [docker provisioner](https://www.vagrantup.com/docs/provisioning/docker.html) in Vagrant. A snippet you can use in your `Vagrantfile` (in our case it meant modifying Homestead's Vagrantfile): 

```
# ...
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.provision "docker" do |d|
        d.pull_images "adobe/s3mock"
        d.run "adobe/s3mock",
          args: "-p 9090:9090 -p 9191:9191"
    end
    # ...
```

However, to get MinIO in Homestead, all you have to do is enable it in the `Homestead.yaml` file:

	features:
		- minio: true

In versions 5.7+ you can also pre-define buckets and their policies that should be provisioned for you in a separate, `buckets` section. Beware that you can add that configurations in previous versions without triggering any errors, but it will just be ignored. 

Credentials will also need to be updated. MinIO that bundles with Homestead uses a dummy login and password, but unlike the S3Mock (at least by default), it actually checks them, so update your configuration accordingly.

Last thing to do is to do is to update local configuration to use thus provisioned service. Depending on whether you use Flysystem, Laravel's Filesystem or AWS SDK directly, this step might look differently for you. The important part is that with a local service you'll need to use something called "path style endpoint" for AWS API. Laravel's documentation gives an [example for the Filesystem configuration](https://laravel.com/docs/5.7/homestead#configuring-minio). The crux of the matter is that because the service is local, buckets url's will no longer be conveniently generated for you by AWS. The way around that, bar some local DNS configuration, is to use a static domain and put the bucket name in the path of the url. 

Apart from that, it's business as usual. All the logic written for the actual S3 should work with your local substitute. 
	
## Downsides 

Not everything is rosy though. All of the services strive to keep their API S3 compatible, but your mileage will vary depending on how many features of S3 you actually rely on. 

Examples I've encountered include:

* needing to change from `public` policy to `download` to achieve a result similar to AWS's own "public objects". Somewhat frustratingly, I could not find a clear explanation of policy differences in MinIO docs. I still feel like I was missing some key piece of information to set it up better, but it didn't help that at the time there was no one centralised information source on available polices. Therefore I'd suggest to check if features like hosted websites, complex ACL setups, CORS policies or object life-cycles will be sufficiently supported for your needs.
* some of the aws cli commands just would not work. Most frustratingly `s3 ls` with an endpoint url defined would just throw an error. Same story with third party browsers like Dragon Disk (tried that and some others just for due diligence, didn't like any of them)

## Conclusion 

All the solutions performed well enough to warrant a recommendation (see the caveats above though). Using a local replacement for S3 makes development feel a bit safer and makes testing less stressful. If you're considering it, just give it a try and see if it's an (almost) drop-in replacement or not.
