---
layout: post
title: Debugging outgoing requests with ncat
date: 2016-01-18
published: true
categories: debugging ncat
---

I had an interesting problem recently:

> An application makes http requests on predfined events to a specified url and we need to verify what exactly is
> being sent.

There are many ways to deal with that, from dumping outgoing request objects to listening in on outgoing traffic with
Wireshark. But I have been a fan of `nmap` and its toolset, so I though that I would be a good opportunity to employ
`ncat` -- an `netcat` reimplementation shipped with `nmap`. 

`ncat`, is as it precursor `nc`, a "Swiss Army Knife" (see `man nc`) of network tools. One of the many things it can do
is to listen for incoming traffic and print it to StdOut. So all I needed to do is to point the app to a url with `ncat`
listening. 

The setup I have for development is a Vagrant box within a \*nix compatible system (the shiny one). 

Setting up `ncat` on the host system is straightforward enough:

    ncat -lk 0.0.0.0 7777

`-l` is for listen, `-k` is for keep-alive, `0.0.0.0` points to localhost in a way that will make it possible to connect
to it from the outside world, `7777` is the host post number.

To access that from the VM, we need an address. I have Vagrant set up a private network, so my host machine acts as a
gateway for the guest system. So I need the gateway address:

    netstat -rn 

and look for a gateway that is not pointing to localhost :). In my case it is `10.0.2.2`, might be a standard for
Vagrant boxes, but I am not sure. Now I know I need to ping `10.0.2.2:7777` from my guest system to reach my `ncat` listener on the host
system:

    curl -X POST 10.0.2.2:7777 --data '{"hello": "world"}'

`ncat` ouput on the host machine:

    ncat -lk 0.0.0.0 7777
    POST / HTTP/1.1
    User-Agent: curl/7.38.0
    Host: 10.0.2.2:7777
    Accept: */*
    Content-Length: 18
    Content-Type: application/x-www-form-urlencoded

    {"hello": "world"}

This way I know it works. 

All that was left was to put that `ncat` listener address in place of the target url in the app and done!
