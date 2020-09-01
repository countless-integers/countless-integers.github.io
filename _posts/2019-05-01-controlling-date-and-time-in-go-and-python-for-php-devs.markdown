---
layout: post
title: Controlling date and time in Go and Python for PHP devs
date: 2019-05-01
published: true
categories: development
tags: php python go 
---

## Changing datetime formats or transforming strings into date objects

Main use cases:

* dealing with user input in different formats
* re-formatting date time without having to know the exact input format

### PHP

It's as easy as:

```php
strtotime(string $dateTime): int
// or, even better:
new DateTimeImmutable(string $dateTime)
```

First one returns a timestamp, second is [an object][datetimeimmutable] with quite a lot of functionality built-in. The object is not perfect
(in fact it's PHP-s second attempt at it, first one being a mutable [`DateTime`][datetime]), especially when you start
using `diff` functions i.e. on datetime objects from different time zones. In fact not being explicit about timezones
was the most common source of head-aches for me in the past (by default server tz will be adopted), so
beware.

One of the interesting features is the ability to parse "natural" language date time strings like "next year", "+2 hours". I found that quite useful in the past for making cli interfaces a lot more user-friendly.[Reference for supported datetime formats][supported_formats].


[datetime]: https://www.php.net/manual/en/class.datetime
[datetimeimmutable]: https://www.php.net/manual/en/class.datetimeimmutable.php
[supported_formats]: https://www.php.net/manual/en/datetime.formats.php

### Python

Date format recognition magic does not come out-of-the-box. There is [a structured date parser][strptime] though:

```python
import datetime

datetime.datetime.strptime('2077', '%Y') -> datetime.datetime
```

However it will raise errors if the string cannot be parsed. [Reference of date format options][date_format].

Anyway, since batteries were not included this time, to the pip-mobile! [`dateutil`][dateutil] to the rescue. It does
have a function lets us get the same behaviour as PHP:

```python
from dateutil.parser import parse
parse('2011') -> datetime.datetime
parse('9AM')
```

Unfortunately it's not capable of parsing strings like 'tomorrow' as PHP date functions can. Also good luck figuring out
what happens when you do `parse('2')`, because it's not going to be an error...

[strptime]: https://docs.python.org/3.7/library/datetime.html#datetime.datetime.strptime
[date_format]: https://docs.python.org/3.7/library/datetime.html#strftime-strptime-behavior
[dateutil]: https://dateutil.readthedocs.io/en/stable/index.html


### Go

Similar to Python, golang comes equipped with structured time parsing functions. However its time format definitions are somewhat confusing, yet
convenient to use:

```go
package main

import (
	"fmt"
	"time"
)

func main() {
    const formatExample = "2006-Jan-02"
	t, _ := time.Parse(formatExample, "2077-Feb-22")
	fmt.Println(t)
}
```

However, that is a bit of a double-edged sword as messing up the format, which is very easy i.e. `2000-Jan-01`, will leave you with a
null date of `0001-01-01 00:00:00 +0000 UTC`. So on one hand it makes the format string value more self-documenting, on
the other it can an arrow to your knee. More about time formats
[here][https://golang.org/pkg/time/#example_Time_Format].

As for a module that would resemble the behaviour and features of PHP functions -- I haven't found one yet. TBC

[time.parse]: https://golang.org/pkg/time/#Parse
[time.format]: https://golang.org/pkg/time/#example_Time_Format
[php2golang]: https://www.php2golang.com/method/function.strtotime.html


## Calculating time differences between dates and time

Main use cases:

* getting the absolute difference between datetimes i.e.

### PHP

TBC

### Python

TBC

### Go

TBC
