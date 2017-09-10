---
layout: post
title: Make cmus play nice with clementine
date: 2015-09-20
published: true
categories: linux
---
## TL;DR
I've written a tiny script to allow me to bind media keys to the currently used audio player.

## Backstory
<div class="collapsable">
<p>
Some people collect stamps, others cook exquisite dishes and other like to get drunk and cause trouble in public
transportation. I like to fiddle with my Arch Linux machine at home. It's good to have a hobby, right?
</p>
<p>
My setup likes to quit on me after package updates. Being a rolling release, Arch does that every now and then. Lately
my KDE apps stopped rendering correctly. It made interacting with most of them impossible. Clementine in particular
caused me much grief, since you can't do much with it without its GUI controls. A major annoyance, one in a long line,
but I'm not really complaining because apps dying make you learn something new. Finding a cli media player being
a case in point here.
</p>
<p>
I have looked at cli players before, but usually dropped them because I couldn't make them work with global media
control keys -- an important feature for me. This time round I decided to make it work whatever it takes.
</p>
</div>

### The player
I chose [cmus](https://github.com/cmus/cmus) as my clementine alternative. I used it before and I liked the interface.
Some of the keybinding resemble those of vim (well home row <kbd>hjkl</kbd> at least). It's pretty quick to setup and
use. Library scanning is also quite speedy. Advantages all around. There's plenty of good posts and documentation for
cmus, so I won't delve into it's use and virtues here. I'll post some links below though[^1]

## The bind
So cmus worked great, but it doesn't respond to media keys. It does have an utility to allow for external control of
it's functions aptly named `cmus-remote`. With it you can toggle play/pause, switch to next track and so on. I don't
care much for volume control, because I prefer to leave that to the system. So all I have to do is to hook up
`cmus-remote` to global keybinding.

There are many ways to achieve that, but I used the simple, GUI way. KDE has a setting panel for configuring keybindings
and it looks like this:

{% include image.html uri="/img/cmus.art.2.png" description="setting keybinding on the media-play key" %}
{% include image.html uri="/img/cmus.art.3.png" description="setting custom binding to cmus-remote" %}

There is a little hiccup after setting those keybindings -- now other players (e.g., clementine) aren't able to use those media key bindings.

Bash scripting to the rescue:

~~~ bash
#!/bin/bash
if pgrep "clementine$"; then
    if [ -f /Applications/clementine.app/Contents/MacOS/clementine ]; then
        /Applications/clementine.app/Contents/MacOS/clementine -t
    fi
    clementine -t 2>/dev/null
elif pgrep "cmus$"; then
    cmus-remote -u 2>/dev/null
fi
~~~

Now I made that executable and put it in `~/bin/mediaToggle.sh` (which btw. is already in my `$PATH` lookup).

{% include image.html uri="/img/cmus.art.1.png" description="setting custom binding to newly written script" %}

Now, when clementine would be running <kbd>play</kbd> would interact with it. But when it wouldn't run it'll try to
toggle play on cmus instance (it'd have to be running, though). Great.

## Last words
<div class="collapsable">
<p>
So here I am: I wanted to play some music to relax after work, but ended up switching media player, writing some
hack-script to make it work the way I wanted it to and in the end writing all that up in this blog post. All because of
some unexpected glitch in qt app (?) rendering.
</p>
<p>
I won't be replacing clementine with cmus (because portability, companion app with remote and media import and general
awesomeness), but it's nice to have a reliable alternative like that.
</p>
</div>

[^1]: some reference material for cmus:

{% include collapser.html %}
