---
layout: post
title: PHP Roundtable about DDD
date: 2016-06-13
published: true
categories: DDD php
---
Loose notes and bookmarks to fragments of PHP Roundtable panel on DDD with Mathias Verraes, Ross Tuck and Chris Fidao. Whole thing is about 2 hours long, so I decided to make some bookmarks in case I wanted to go back to it or reference it somebody. Unfortunatly I could not find the [shownotes or transcript for this episode](https://github.com/PHPRoundtable/show-notes/tree/master/episodes). 

Whole thing can be found under [this URL](https://www.phproundtable.com/episode/domain-driven-design-in-php).

## Essence of DDD, answered by M. Verraes
[4m00s](https://youtu.be/CS_22l-LEtM?t=4m00s)

how to explain domain to a MVC user:
[7m26s](https://youtu.be/CS_22l-LEtM?t=7m26s)

distinction between strategic (understanding the domain) and tactical DDD (implementation, e.g. events) [R. Tuck, M. Verraes]:
[10m8s](https://youtu.be/CS_22l-LEtM?t=10m8s)

The code that makes money should be the cleanest and the best possible quality.

DDD is not a design pattern. It is a way of thinking about business and transferring that knowledge to code that models the business in a way understandable by a domain expert.

Strengths and weaknesses of DDD [M. Verraes]:
[16m10s](https://youtu.be/CS_22l-LEtM?t=16m10s)

## Aggregate
Is an entity that has been designated to be streamline communication through for a group of VO or entities.

Can be used to define a boundary for transactions.

Aggregate is not strictly part of a domain, because business does not "know" about them. [M. Verraes].

It is a tactical pattern. [R. Tuck].

## Domain events
Something that happens that the business would be interested in:
[46m59s](https://youtu.be/CS_22l-LEtM?t=46m59s)

## Factories
"Objects for pooping out new objects":
[59m5s](https://youtu.be/CS_22l-LEtM?t=59m5s)
It is just about the standard OOP factories.

## Repositories
Objects for getting objects from persistence layer:
[1h2m0s](https://youtu.be/CS_22l-LEtM?t=1h2m0s)

## Hexagonal architecture 
Introduction, not too informative and a bit chaotic:
[1h3m30s](https://youtu.be/CS_22l-LEtM?t=1h3m30s)

Difference between DDD and hexagonal architecture:
[1h7m50s](https://youtu.be/CS_22l-LEtM?t=1h7m50s)

a slightly more cohesive explanation:
[1h8m29s](https://youtu.be/CS_22l-LEtM?t=1h8m29s)

Examples of hexagonal architecture and DDD going hand in hand:
[1h9m17s](https://youtu.be/CS_22l-LEtM?t=1h9m17s)

M. Verraes on the meaning of hexagons :) :
[1h12m45s](https://youtu.be/CS_22l-LEtM?t=1h12m45s)

## Post panel discussion
2 words about Broadway Framework:
[1h16m38s](https://youtu.be/CS_22l-LEtM?t=1h16m38s)

Web frameworks versus general design principles:
[1h20m34s](https://youtu.be/CS_22l-LEtM?t=1h20m34s)

[M. Verraes] Common, simple problem for people transitioning from MVC- to DDD-thinking: structuring directory structure in a way that separates classes by function and not by domain. 

[R. Tuck] on splitting application into layers:
[1h36m40s](https://youtu.be/CS_22l-LEtM?t=1h36m40s)

DDD and REST APIs
[1h38m51s](https://youtu.be/CS_22l-LEtM?t=1h38m51s)

Switching from CRUD thinking to DDD thinking:
[1h44m00s](https://youtu.be/CS_22l-LEtM?t=1h44m00s)

Frequent issues with DDD:
[1h48m47s](https://youtu.be/CS_22l-LEtM?t=1h48m47s)

How to make first step towards building apps in a DDD way:
[1h45m29s](https://youtu.be/CS_22l-LEtM?t=1h45m29s)

I have omitted a lot the fragments, some on purpose, some by mistake. I really wish they they would edit those things to some more managable and focused format. Still there is a lot interesting stuff in there, so enjoy.
