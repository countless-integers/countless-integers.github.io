---
layout: post
title: chsh to zsh
date: 2016-06-11
published: true
categories: infrastructure
tags: shell zsh
---
The time has come. I am currently in the process of revisiting every tool I use and looking for better alternatives. After living in denial for years I have come to a decision to switch from trusty Bash to ZSH. 

## Ain't nobody got time for that...
To make it easier for myself I went with what is called a ZSH framework. Namely `oh-my-zsh`. It comes with a lot of stuff out of the box, like aliases, plugins, themes, sensible defaults. E.g. it enables highlighted arrow navigation in autocompletion lists. It was even polite enough to backup my existing `.zshrc` to `.zshrc.pre-oh-my-zsh` -- nice touch.

## Stuff I love

### Fuzzy path expansion
Let us say you have a path like `./src/Your/Super/Java/Like/Namepaced/Class.php`. Using fuzzy path expansion you should able to get there with something like `cd s/y/j/clas` (or any combination of unique path fragments). It is a lot less typing and after a while you get more and more efficient with typing. Which, as a die hard Vim fan, is good. 

### Autocomplete "fixes" wrong caps 
`ls path/dir<tab>` can expand it to the actual name like so `ls path/Dir`. It also works with fuzzy path expansion mentioned earlier. Neat.

### Autocomplete almost everywhere (and if not, then there is probably a plugin that will provide that)
You can try autocomplete in a lot more places with zsh. E.g. `pgrep`, `kill`, `ssh`. It also helps with options completions, by displaying their description in the automcomplete choice list. No longer do I have to scratch the onliner I was writting just to `--help` my memory to come up with that `-oBsCuRe` option for nmap.

### Monits
Standard commands like `mv` or `rm` will actually ask you for confirmation by default. It is a smart default. Does not work all in all the cases, but I have not really bothered to notice the actual patern of it.

## Plugins
`Oh-my-zsh` by default, in full install, comes with a lot of them. Usually they are nothing more than shell scripts that get sourced when you open the shell (so do not load them all, duh). The ones I have found most useful are:

* **jira** -- create / open issues from the command line, something that I found pretty useful. Where I work, we bury jira issue names in commits/branch names so this makes it easy for me to quickly look up the corresponding issue in jira. Lookup installation instructions, because it will need either an env variable or a local file with jira URL (it does not need any credentials, because it only opens up a correct link in the default browser).
* **docker** -- autocompletion for docker commands. E.g. it can autocomplete container names.
* **composer** -- autocompletion for composer commands.
* **web-search** -- so I can start searches from command line. I do not even know why.
* **common-aliases** -- because typing hurts...
* **z** -- it is a bit unusual, because of the installation process. Apparently you need to source the script yourself (or put it on the path). What it does is to allow you quickly `cd` into most often visited directories (it keep tracks of that). `z <tab>` will display a list of those -- simple enough and can save a lot of time. Of course works with the usual zsh autocompletion magic, e.g. highlighted cursor navigation.
* **syntax highlighting** -- real-time syntax highlight for shell commands. It will highlight wrongly typed commands in red, e.g. if you type `lss` instead of `ls` it would mark it in red, same as an editor would. Check the installation instructions carefully.

### Themes
There is a lot of them to choose from and I have found a lot of decent ones (separate lines for commands and "status", clock, VCS integration). I've chosen `avit` for now and added a clock on the right side of the prompt, because I like to see when a command was executed.

## Conclussion
I am still exploring the functionality of zsh, but I can already tell that I do not want to go back to plain Bash. Fuzzy path autocompletion and autocompletion preview are killer features for me and I am already so used to them that running Bash afterwards felt frustrating. You can call it lazy, I will call it more productive, because it takes my mind of getting the silly stuff right all the time. 

## Useful references to get started

* [General tips](http://code.joejag.com/2014/why-zsh.html] (and this)[https://coderwall.com/p/1y_j0q/zsh-oh-my-zsh-my-top-tips-for-daily-use)
* [A bit deeper dive into glob(-ish) syntax and modifiers](http://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/)
* [The indispensable ArchLinux wiki](https://wiki.archlinux.org/index.php/Zsh)
* [Which helped me to find prompt expansion codes for adding a clock to my prompt (`%*`)](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html)
* [Looks antiquated, but still, mostly, relevant](http://zshwiki.org/)
* [Oh-my-zsh github page](https://github.com/robbyrussell/oh-my-zsh)



