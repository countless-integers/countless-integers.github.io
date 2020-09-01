---
layout: post
title: The Linux terminal experience on Windows 10
date: 2017-04-01
published: true
categories: infrastructure
tags: windows
---

After the news about Microsoft including some sort of Ubuntu-base Linux console in Windows 10 anniversary update broke out I was a bit skeptical. No about the idea itself, that makes perfect sense and should have been done a long time ago, but about the implementation. After all both systems are vastly different, e.g. in terms of file systems and access to them (even minor stuff, like the path separator, is different). However with some virtualization and throwing enough money at the problem it did seem possible to pull-off.

# How to enable it?
Of course it is not enabled by default, there is plenty of tutorials on the subject. I went with [OMG Ubuntu one][1]. It went quite smoothly.

First thing I have noticed though is how ugly this looks. Looking at terminal fonts all day makes some people develop a certain fetish for console looks. Seems like I am among those weirdos as well. In comes [cmder][2], an open-source terminal emulator. This one looks acceptable, gorgeous compared to the one offered on Windows by default. It also has some nifty features, which I will not mention here. Ah, and it also takes a while to install...

Having those two in place we can run the bash console from cmder like so:

    bash

(see "Problems?" section before you do though) 

# What can it do?
A great many things, I have been told. From a developer perspective: it should give us access to tools we take for granted (like `git`, `curl`, `vim`), run web-servers and generally pretend we are running a Linux server.

To put it to test, I have tried to set-up a dev environment for this blog. Simple, yet it appears to require ruby2+ these days, which is not the one included in our Ubuntu version (it ships with 1.9+). 

Not to mess around to much, I have found [an Ubuntu PPA][3] hosting all the packages I had needed. Installation went like this:
```
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update

sudo apt-get install ruby2.3 ruby2.3-dev
sudo gem2.3 install jekyll
```
I took some googling, but it worked. [Directory watching seems to be failing][4], which is a major bummer for anyone using web-dev tools, but it is a start. The built-in web-server was also operational.

Another thing that worked, at least in basic example was a simple http node server. Node version also needed [a little upgrade][5], but it does seem to work.

Other than that FS access seems to work as well, which is baffling to me. Sharing FS between host machines and virtualization ones is still a bit mysterious to me, so maybe it is the concept of it in general, rather than this specific case of it (and yes, I am aware that technically this Ubuntu on Windows contraption is neither virtualization or emulation, but on it sure feels like it).

# Problems?
I have noticed one. While trying to execute a simple `mv` command on a git repository everything froze. So I was unable to open any new bash shells (interesting) or kill that process. Well [killing a process on Windows][9] has always been something of a hit-and-miss experience for me anyway. In a world of imperfect developers producing imperfect code this might be a major issue. 

Another one was connected to cmder more than with "linux mode". There is a [known issue][10] with the usage of arrow keys, while in bash. Running:

    %windir%\system32\bash.exe -cur_console:p1
   
should solve it.

# Why bother?
For me it was just about curiosity. Doing any development (in non-Microsoft technologies) has always been a major pain on Windows (despite what MS claims in almost every MS-sponsored talks I have ever heard). Having an option is much-appreciated. 

# What is next?
The upcoming Creators Update is supposed to improve the [experience on many levels][6]. More important than the specifics is the fact that this means that Microsoft does seem to keep at investing in this feature of their system. Some extra [explanations about the upcoming update][7] as presented by MS themselves, the interesting part starts around minute 18.

It is also possible to report issues in [a civilized manner][8] and looking at what is coming in the next release, somebody at MS does read those.

So, for better or worse, jumping from pc gaming to development does look easier than it used to be.  




[1]: http://www.omgubuntu.co.uk/2016/08/enable-bash-windows-10-anniversary-update
[2]: http://cmder.net/
[3]: https://github.com/Microsoft/BashOnWindows/issues/216
[4]: https://github.com/Microsoft/BashOnWindows
[5]: https://www.brightbox.com/docs/ruby/ubuntu/
[6]: https://thenewstack.io/windows-10-creators-update-means-windows-subsystem-linux/
[7]: https://channel9.msdn.com/events/Windows/Windows-Developer-Day-Creators-Update/Developer-tools-and-updates
[8]: https://nodejs.org/en/download/package-manager/
[9]: http://stackoverflow.com/questions/49988/really-killing-a-process-in-windows
[10]: https://github.com/Microsoft/BashOnWindows/issues/1154