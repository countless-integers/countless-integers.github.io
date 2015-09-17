---
layout: post
title: Duck typed interfaces in ZF2 Module class
date:   2015-09-01
published: true
categories: php zf2 interfaces
---
ZF2 `Module` class methods conform to [DuckTyping](https://en.wikipedia.org/wiki/Duck_typing) but it's nice to know where all those methods came from. That would be [feature interfaces](https://github.com/zendframework/zend-modulemanager/tree/master/src/Feature) from ModuleManager component. So if you're not sure what feature can you advertise in your `Module` class it's a good place to check. I couldn't find any mention on this in the official docs, although it was hinted in the ["Advanced configuration article"](http://framework.zend.com/manual/current/en/tutorials/config.advanced.html#configuration-mapping-table). 

Although it's not necessary to declare the implementation of these interfaces I found that doing so it improves readability and helps newcomers to better understand where did those methods came from. Because duck typing is not too common in PHP I got a lot of blank stares and WTF-ucks from my colleagues who tried to figure out how `Module` worked.

I suppose that this (duck typing in `Module` class) was supposed improve modules portability, but I have yet to see a popular module that benefited from this.

Tiny cheatsheet of interfaces and methods they declare (base on the before-mentioned ZF2 docs page):

|Iterface class 								| Method						|
|:----------------------------------------------|:-----------------------------:| 
|`ControllerPluginProviderInterface`			| `getControllerPluginConfig()` |
|`ControllerProviderInterface`					| `getControllerConfig()`		|
|`FilterProviderInterface`						| `getFilterConfig()`			|
|`FormElementProviderInterface`					| `getFormElementConfig()`		|
|`HydratorProviderInterface`					| `getHydratorConfig()`			|
|`InputFilterManagertFilterProviderInterface`	| `getInputFilterConfig()`		|
|`RouteProviderInterface`						| `getRouteConfig()`			|
|`SerializerProviderInterface`					| `getSerializerConfig()`		|
|`ServiceProviderInterface`						| `getServiceConfig()`			|
|`ValidatorProviderInterface`					| `getValidatorConfig()`		|
|`ViewHelperProviderInterface`					| `getViewHelperConfig()`		|
|`LogProcessorProviderInterface`				| `getLogProcessorConfig()`		|
|`LogWriterProviderInterface`					| `getLogWriterConfig()`		|

All interfaces are in `Zend\ModuleManager\Feature` namespace.
