---
layout: post
title: var_dump alternatives
date: 2015-09-06
published: true
categories: development
tags: php debugging
---

TL;DR
-----
If you want something better to dump variables than `var_dump`, get Kint.

Introduction
------------
When I can't be bothered to turn on Xdebug just to debug some mysterious variable, then I take a dump (caution: more bad poop puns ahead). It comes out in different shapes and sizes. Sometimes it's hard to make out anything out of it and instead of saving time I'm loosing it. XDebug is comprehensive and gives an insight into code that dumps won't ever provide, but PHP can do a lot better than `var_dump`.

So one fine day I went for a hunt on the internets for a worthy replacement. By worthy I mean:

* easy to install and invoke 
* doesn't brake other things
* is context-aware, e.g. it won't try to output array as a string

No big expectations there, right? So let me go over what I found.

Symfony VarDumper
-----------------
Invocation is a simple `dump` global function that takes one argument.

Pros:

* simple invocation
* minimal installation
* [distinguishes between `cli` and `www` environment](https://github.com/symfony/var-dumper/blob/master/VarDumper.php#L32)
* (a bit far-fetched) part of the Symfony ecosystem, so I'd expect it to receive timely updates and upgrades, perhaps even some SF integration

Cons:

* `dump` is still longer that e.g. `d`
* no option to stop script execution
* no way to pass multiple vars in one invocation, so you have to call `dump` with every variable you want to see

Read more about it:

* [Symfony docs](http://symfony.com/doc/current/components/var_dumper/introduction.html)
* [VarDumper on github](https://github.com/symfony/var-dumper)

Zend Framework Debug
--------------------
It's a component of ZF. Invocation is: `\Zend\Debug\Debug::dump($var);`... As far as "easy to invoke" is concerned, the
description might as well end there. But:

Pros:

* (if your project is based on ZF2) shipped with ZF2

Cons:

* the invocation is just too damn long

Read more about it:

* [ZF docs pages](http://framework.zend.com/manual/current/en/modules/zend.debug.html). If the page is up that is[^1].

Kint
----
The basic invocation of Kint is `d($var)`. It does not get any simpler than that. It also allows for no-formatting output through `s($var)`. But it doesn't end there. `ddd($var)` (used to be `dd`, but then it got deprecated for compatibility) will die after dumping (same thing with `sd($var)`) and it also does magic tricks with, what they call, real time modifiers. E.g. `+d($dump)` would bypass dump depth limits, `@s($var)` would return the output to a variable for capture, `!d($var)` would expand all output in HTML mode. It also comes with optional keyboard navigation, foldable output (like VarDumper), type/visibility detection and many more.

Among the features I've not seen anywhere else is signing every dump with the exact place it was made (fqcn and line number) and that a lot better for me than labeling the dumps.

What I like in particular is that it also outputs useful info about objects you dump, like public method/variable names. So no more `var_dump(get_class_methods(get_class($object)))` and similar gimmicks.

I could not find anything as good as Kint. It's a winner.

Pros:

* many useful modes
* shortest possible invocation
* modifiers
* comprehensive output
* discerns `cli` and `www` environments

Cons:

* it doesn't make toasts
* recently it has been getting really complex, so occasional, unexpected error might occur (e.g. [this](https://github.com/raveren/kint/issues/160))

Read more about it:

* [github page](https://github.com/raveren/kint/)
* [blog page](http://raveren.github.io/kint/) but it seems slightly out of date.

Notable omissions
-----------------
* [LadyBug](https://github.com/raulfraile/Ladybug) -- I kinda stopped liking it after seeing `composer require` output
that looked like it wouldn't end. Why so many dependencies LadyBug?

Conclusion
----------
Apart from ZF2 dump, which doesn't really fit my search criteria, all of the above tools yield some improvements over vanilla `var_dump`. However not all 'dumpers' were made 'equal' -- some just can take a dump better than the others (see what I did there?). Kint is my favorite and I use it every time I don't feel like starting a Xdebug session. Hats off to the creator and the contributors -- you made my life easier.

All of the above-mentioned tools are available through composer, so getting them to work is straightforward (seems
obvious, but I still remember the days we didn't have composer).

If you know anything better than Kint, let me know.

[^1]: if you're detecting a little passive-agressive note, then your instincts are working correctly. I'll post something about my experience with ZF2 later on.
