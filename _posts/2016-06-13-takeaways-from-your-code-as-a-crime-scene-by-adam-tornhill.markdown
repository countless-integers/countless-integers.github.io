---
layout: post
title: Takeaways from "Your code as a crime scene" by Adam Tornhill
date: 2016-06-13
published: true
categories: development
tags: vcs static-code analysis git
---

...more than a catchy title.

There is a lot of good ideas in this book, so I decided to write some of them down just to commit them to memory. It is not a review, nor an attempt at creating an abstract. Therefore I will omit a lot of stuff and only concentrate on the things I found novel or unusual.

## Analyzing VCS logs

When I think of static code analysis, things like CLOC, PHPMD or compiler checks (in languages other than PHP, of course). I have not really been introduced to the concept of analyzing code base history up until I started reading this book. Git repository (or any other VCS) surely is a big pool of information, yet it never even crossed my mind to do so.

The techniques described in this "Your code is a crime scene" are not "strict science". They are heuristic methods that are designed to quickly point out **possible** problems with code. In words of the author:

> Complexity is only a problem if we need to deal with it. (...) Each improvement to a system is also a risk, as new problems and bugs may be introduced. We need strategies to identify and improve the parts that really matter.

When presented with a task of refactoring the entire code base (or a refactor without a particular scope in mind) this might be a useful method to get started.

## Tools

### Code Maat
[Code Maat](https://github.com/adamtornhill/code-maat) is an open-source tool developed by the author for analyzing VCS logs. It's command interface is not the most user-friendly, but there are plenty of usage examples in the book. In itself it does not handle results visualization -- that has been left to 3rd party libraries (e.g. D3) or other tools by Tornhill.

Moving on to analyzes that this tool can help us with...

## Applications

### Identifying code hot-spots
The concept of hot-spot tracking was taken from the crime-fighting world, were it is used to predict most likely locations where a criminal will strike. It is based on some simple assumptions (e.g., criminals operate within a fixed radius, so establishing where that are is and the commonalities between previous crime location can be key to catching them) and meticulous data gathering.

Same principle can be apply to software -- "code that changes is likely to change again". Reason for those abnormally frequent changes being bugs and problems with the design. It is a bit far-fetched statement, because there can be a multitude of reasons for code to change often e.g. various designs are being tried out, code base is in the stage of a rapid growth, some automated tool modified the indentation or added doc block comments. Therefore author proposes supporting that with additional metrics like code complexity (measured with metrics like lines of code, cyclomatic complexity, average method length). However imprecise that might be it turns out that it can be a quick way to find places to take a closer look.

### Detecting logical coupling
Logical (temporal, change) coupling can be hard to spot. In the context of looking for potential refactoring candidates it is particularity annoying, since logical coupling is high up the list of things we do not want in our code. It can lead to unpredictable errors when we try to change something without being aware of the coupling and induce the work overhead when we do. Classes that loose cohesion are therefore a lot harder to maintain and reason about.

Author proposes commit history analysis to identify files that often change in the same revision. Code Maat can perform such analysis feeding off pre-formatted VCS logs.

Blindly applying this technique will result in a lot of false positives like: class files with unit tests tend to be committed together (at least in an ideal world), classes that are intentionally coupled (with explicit dependencies) are also often committed together etc.

### Identifying knowledge concentration and improving communication
Another interesting insight is that we can reduce the number of bugs and smooth out the overall development of a project by identifying main developers of temporally coupled code and making sure they communicate appropriately (frequently and efficiently). This is one of the practical takeaways from Conway's law:

> Organizations which design systems ... are constrained to produce designs which are copies of the communication structures of these organizations
> -- <cite>[M. Conway](https://en.wikipedia.org/wiki/Conway%27s_law)</cite>

Special attention should be passed to code which main developers have left the project. Author rightfully remarks that programmers that leave the project take they their knowledge with them (as it is very difficult to pass along in full) and therefor make some parts of the code base more prone to failure.

### The "human aspect"
A lot of emphasis in the last chapters of the book has been on psychological aspects of coding. It is another tie in to the title and leif motive of the book. In the end when trying to improve quality you cannot overlook the "human aspect" of things -- things like group behaviour, individual motivation, communication and work styles.

One of the interesting things mentioned in those chapters is a really good definition of design patterns:

> Patterns have social value. As the architect Christopher Alexander formalized patterns, the intent was to enable collaborative construction using a shared vocabulary. As such, patterns are more of a cummunication tool that a technical solution.
> taken from "Use beauty as a guiding principle" chapter

## Code churn
Code churn is a metric of code change occurring in a project. It is considered to be a good predictor of problems in the code base as high value of change often leads to bugs or is a symptom of inefficient development process. What we want is a steady churn, where changes are maintainable and integrated often. You can actually make an argument for that by looking at the churn and the number of spotted defects (e.g. bug tickets, test errors, etc).

Code churn is, as all heuristics, not infallible. There can be many reasons for a high churn rate e.g. adding a lot of static files, generated code (assuming that since it is generated it is less likely to fail, because it was already tested), different commit styles (everyone has that friend who just likes to drop a PR bomb at the end of a sprint).

Relative code churn is a metric where a nominal number of changes is compared with the total number of lines in a changed file. Although using a relative value sounds less error prone, the research cited by the author states that there is little difference in that regard between the two.

It is also worth noting that we can get similar metrics already from tools like Github. Every repository now has a "Graphs" page where we can ponder on things like "Commits" (number of commits per day), "Code frequency" (shows the ratio of lines added to lines deleted) and also gain some insight into contributions of individuals involved in the project (might help to spot things like: people committing in bulk).

More about code churn:

* [MSDN page](https://msdn.microsoft.com/en-us/library/ms244661.aspx#churn_measures). Search results for "code churn" seems to be dominated by content coming from Redmond.
* ["Use of Relative Code Churn Measures to Predict System Defect Density" by Nachiappan Nagappan and Thomas Ball](https://www.st.cs.uni-saarland.de/edu/recommendation-systems/papers/ICSE05Churn.pdf)

## Misc

### Visual code analysis
Silly concept from chapter 3. Get a rough idea of code complexity looking at the negative space (indentation and whitespace). The analysis is easy to perform in both automated and manual way (as is just through a glance at a code file).
There is even some theoretic work done on that [subject](https://encrypted.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiSi9mIoJHNAhWCOBoKHZAYBbcQFggcMAA&url=https%3A%2F%2Fplg.uwaterloo.ca%2F~migod%2Fpapers%2F2008%2Ficpc08-abram.pdf&usg=AFQjCNHxpNWIuLy2ey_Uy2O-3x_Nqa3oTw&sig2=EXjD8X_9hqSYJQgCZbFn2w).

### Keep a decision log
Looking at code, even a comprehensively documented one, might not reveal the original intent of it is authors. This is especially true for long-running projects with many contributors. Memory and code comments might not be enough to capture the intent. And understanding the original intent can explain why or where things went wrong.

### Analyzing common phrases in commit messages
One of the little heuristics described in the book is analyzing keywords from commit messages. The assumptions here is that teams / projects riddled with problems will use a negative language full of ugly words like: "bug", "fix", "hotfix", "bughotfix", etc. Author used log files to export commit messages and build word maps using tools like [Wordle](http://www.wordle.net).

## Glossary and interesting concepts

### Process loss
Process loss is a theory that teams and organizations cannot operate at 100% efficiency. In terms of development, one of the implications of it is that introducing additional developers to team makes it less efficient overall due to increased cost of communicate, organize and coordinate. Pretty much the opposite of synergy.

> Adding manpower to a late software project makes it later
> -- <cite>Brooks’ law</cite>

## Pluralistic ignorance
> Pluralistic ignorance happens in situations where everyone privately rejects a norm but thinks that everyone else in the group supports it. Over time, pluralistic ignorance can lead to situations where a group follows rules that all of its members reject in private.
> -- <cite>"Norms, Groups, and False Serial Killers"</cite>

I share this opinion as well. It is also one of the reasons I am not a big fan of "brain storming". Turns out author shares that opinion as well:

> The original purpose of brainstorming was to facilitate creative thinking. The premise is that a group can generate more ideas than its individuals can on their own. Unfortunately, research on the topic doesn't support that claim.
> -- <cite>"Norms, Groups, and False Serial Killers"</cite>

Unfortunately there is no citation to be found, but this is what follows:

> (...) in brainstorming we're told not to criticize ideas. In reality, everyone knows they're being evaluated anyway, and they behave accordingly. Further, the format of brainstorming allows only one person at a time to speak. That makes it hard to follow up on ideas, since we need to wait (...)
> -- <cite>"Norms, Groups, and False Serial Killers"</cite>

Another thing not mentioned there, but described in a different part of the chapter is the effect known as [attribution error](https://en.wikipedia.org/wiki/Fundamental_attribution_error). In terms of development this would mean that we are likely to have a higher opinion of code and ideas of developers who are senior or proved themselves capable in (singular) situations. It makes sense at first, but the errors lie in disregarding less-esteemed developer opinions or overrating that of those more "senior". In other words, putting more trust in a person rather that his individual thoughts and actions. That can lead to a situation where some people are driving a whole project forward, whereas others are just in for a ride. I have often seen this in practice: teams with talented, but insecure and taciturn members, who had a lot of good ideas, but where not feeling comfortable expressing them. This is also one of reasons I believe in the role of a "team lead", who should work on involving everyone.

## Conclusion
The forensic / crime-fighting analogy doesn’t really hold up for long in this book, but it is been an interesting enough premise to get me into it. Aside from that, described techniques were new to me and even though I do not think I will be applying them on a daily basis, that insight will be helpful for analyzing projects in the future.

"Your code as a crime scene" sometimes feels like a academic thesis, but it was actually quite a good read. It is also full of references and citations, which makes it easier to follow up on the described ideas.

All in all, I was positively surprised by what I have read.
