---
layout: post
title: My 2 years with Zend Framework 2
date: 2015-09-05
published: false
categories: development
tags: php zf2 
---

# Introduction
I've been working on a high-traffic website build (from ground up) with Zend Framework 2 for almost two years now. It
appears that is coming to an end so I feel like it'd be a good moment to write down some of my experience with it.
There'll be a lot of grief that I believe is only natural after using a technology long enough to learn its weaknesses.
It's not intended to be comprehensive, well-balanced critique -- I'm not that at this whole blogging thing. 

A lot of people asked my about it though, so I thought that by writing it all down it'll be easier for me to answer
those sort of questions. So I'll take a shot at separating the good from the bad.

# The documentation
If feels like it was written for ZF2 devs rather than framework users. Most of the examples show the components used
apart from their usual context (that is MVC app). So you'll learn how to instantiate a form object, add filters to them
and so on. Great, but there's an easier way to do it, e.g. by implementing certain interfaces and moving all the
configuration into arrays. Take a look yourself (see [form doc page][zf2_docs_form]), most of it is programmatic creation
of form-related objects; the most useful code example is [this][zf2_docs_form_useful].

Then there are errors like [this one](https://github.com/zendframework/zf-web/issues/153), still open. It's not exactly
advertising framework security features nor any robust support. It's an example of something I see as a trend in ZF2 --
lack of thoroughness. From a framework branded with Zend I expect, if not excellent quality and attention to detail,
then at least a visible commitment to pursuing it. Problems like this add up and that expectation fails when confronted
with the reality.

Disqus comments section on the doc pages is useless. It seems that nobody from the dev team monitors those comments and
all that feedback (which can be useful at times) goes unnoticed. If you want to ask a question through that channel,
you'd be better of shouting at a wall -- there's a better chance that your neighbour will be a proficient ZF2 user
who'll answer you, than that you'll get an answer in that comment section. I think doc pages you'd better off without
comments section. All of that should be handled through github issues. 

# Features

## Modularity
It one of the most advertised features of ZF2. I concur, you can make reusable modules based on ZF2. Even I managed to
produce one (closed-source). Not without problems, but those were not related to the framework but to my ineptitude to
design and develop it properly. 

That said I still have an issue with the modules "ecosystem". What I mean by that is how much functionality is already
out there for you to grab and use in your application. I won't discern here between modules, packages, plugin,
extensions etc. What I'm interested is how many times would I need to "reinvent the wheel" as opposed to using an
already established and tested functionality provided by the able-minded people from the framework community. 
Take a look at [zfmodules.com](https://zfmodules.com/). The site itself suffers from a number of problems[^4], but apart
from that notice the number of modules. It's 631 at the moment of this writing. Compare that to 2663 bundles for
Symfony[^5], 5761 for Laravel[^6], 1956 for Yii[^7]. Well it's twice more than 246 resources for Phalcon[^8], but that's
relatively new compared to ZF2.

But you'd say quantity is not as important as quality and I'd agree, at least to some extent. 

## Automation and tooling

# The exceptions

# The architecture and design patterns

# Performance 
ZF2 main page advertises the framework as "high performing"[^1]. I've found out the hard way that this is not the
case. I've done my best to incorporate all the best practices concerning ZF2 performance improvement, but to no avail.
And by the way, there is a lot to do on that front. 

My grief is also with the way that performance benchmarks are often presented. Particularly I remember a great talk by
Gary Hocking[^2] on the subject. It featured a benchmark that said the skeleton app could do 30/40
req/sec. My problem with it is that it doesn't say what hardware was used there. In my experience we could never get ZF2
to perform like that. It's always been single digits per core. 

What's also disappointing is that even implementing ESI[^3] with Varnish didn't help that much. Performance went up to double
digits per core when most of the site was build with ESI modules. That's when it hit the cache, because with a miss...
well let's just say that misses were painful. I write it all down to the expensive bootstrapping of ZF2 apps. Just
raising the app to return a 404 page produced tons of overhead. Time will tell whether adding middleware in ZF3 apps
will help with that.

# Conclusion 
 
[DevOps Reactions said it][devops_reactions_slime_page]: ![It’s a slow, oversized and ugly framework, but we like it][devops_reactions_slime]


[^1]: [see zf2 webpage][zf2_page]
[^2]: [see it on youtube][gary_hockin_zf2_perf]
[^3]: [lookup ESI on wikipedia][ESI_wiki]
[^4]: [zfmodules.com github issues page](https://github.com/zendframework/modules.zendframework.com/issues)
[^5]: [Symfony bundles repo](http://knpbundles.com/)
[^6]: [Laravel packages repo](http://packalyst.com/)
[^7]: [Yii extensions](http://www.yiiframework.com/extensions/)
[^8]: [Phalcon resources](https://phalconist.com/)

[devops_reactions_slime]: http://33.media.tumblr.com/de6a2c2b901f4888f028d437c4c07080/tumblr_inline_ntz75xJLhM1raprkq_500.gif
[devops_reactions_slime_page]: http://devopsreactions.tumblr.com/post/128322627867/its-a-slow-oversized-and-ugly-framework-but-we

[gary_hockin_zf2_perf]: https://www.youtube.com/watch?v=QwpGPlL8oZc
[zf2_page]: http://framework.zend.com/
[ESI_wiki]: https://en.wikipedia.org/wiki/Edge_Side_Includes
[zf2_docs_form]: http://framework.zend.com/manual/current/en/modules/zend.form.quick-start.html
[zf2_docs_form_useful]: http://framework.zend.com/manual/current/en/modules/zend.form.quick-start.html#hinting-to-the-input-filter

