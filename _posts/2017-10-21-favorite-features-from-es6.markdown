---
layout: post
title: Favorite features from ES6
date: 2017-10-21
published: false
categories:
---

# Favorite features from ES6

## Spread operator
There are multiple uses for it. 

With `...` operator it is also possible to transform strings into arrays like so:

    [..."text"] // > ["t", "e", "x", "t"]

which is equivalent to:

    "text".split("")

Another useful thing it can do is concatenating arrays and objects:

    let pizza = [ 1, 2, 3 ]
    const missingSlice = [ 'a', 'b' ]
    const wholePizza = [ 'crumbs', ...pizza, ...missingSlice ] // > [ 1, 2, 3, 'a', 'b' ]

    const you = { a: 1 }
    const me = { b: 2 }
    const us = { ...you, ...me }

Even more examples at MDN

## The Set object/type
A lot of people coming to JS from other languages, i.e. Python, take the existence of "set" type for granted, but it is not as common as it should be (PHP...). It has many uses, on practical one being filtering out duplicated values from an array:

    new Set([1, 2, 2, 1, 3]) // > Set [1, 2, 3]

MDN docs


https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator