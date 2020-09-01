---
layout: post
title: PUT requests to ZF2 RESTful controller
date: 2015-09-17
published: true
categories: development
tags: php zf2 
---

I've recently came across a problem writing a CRUD panel that made my reconsider what I knew about REST and/or request
handling by PHP. Use case was 
for updating an entity that consisted of some flat data and an image. I chose to send form data with PUT method pretty 
much the same way I'd do with creating a new entity with POST form. Turns out that sending that data from an angular app 
isn't a problem, dealing with it server side is. I've compared payloads send with POST and PUT and on their way out they 
look pretty much alike:

This one with PUT:

    ------WebKitFormBoundaryqxNZUgM5f0nFT1Z1
    Content-Disposition: form-data; name="creation"

    {"id":1,"title":"ccc","dateFrom":"2015-08-19","dateTo":"2015-08-22","position":1,"status":0}
    ------WebKitFormBoundaryqxNZUgM5f0nFT1Z1
    Content-Disposition: form-data; name="file"; filename="file.jpg"
    Content-Type: image/jpeg


    ------WebKitFormBoundaryqxNZUgM5f0nFT1Z1--

And this one with POST:

    ------WebKitFormBoundaryaDVU9RBkEiCCgfUT
    Content-Disposition: form-data; name="creation"

    {"title":"sdfsafsa","dateFrom":"2015-09-14","dateTo":"2015-09-30","position":1,"status":0}
    ------WebKitFormBoundaryaDVU9RBkEiCCgfUT
    Content-Disposition: form-data; name="file"; filename="file.jpg"
    Content-Type: image/jpeg


    ------WebKitFormBoundaryaDVU9RBkEiCCgfUT--

One key difference is the presence of a `id` in the PUT request, because it's modifying an existing request it makes 
sense that it's there. Apart from that it looks the same, but it's handled differently
    
* For one thing there's no `$_PUT` like there's `$_POST`, so to even read it you have to resort to things like
`parse_str(file_get_contents("php://input"), $put)`. Maybe [PSR-7] will solve that.
* `$_FILES` is not populated if you send a `multipart/form-data`, but there's a reason for that

Anyway ZF2 has a neat controller to handle requests like that in a restful fashion called 
[`AbstractRestfulController`][AbstractRestfulController]. It maps incoming requests based on their HTTP method and 
parameters:

> POST maps to create(). That method expects a $data argument, usually the $_POST superglobal array. The data should be 
> used to create a new entity, and the response should typically be an HTTP 201 response with the Location header 
> indicating the URI of the newly created entity and the response body providing the representation.
>
> PUT maps to update(), and requires that an “id” parameter exists in the route matches; that value is passed as an 
> argument to the method. It should attempt to update the given entity, and, if successful, return either a 200 or 202 
> response status, as well as the representation of the entity.

It works quite well up to the point when you'd try to send a multipart form with a file. The it'll only take you to the 
`update` method as expected, but you can't really get the data. I mean you could parse the input stream and carve that 
data, but forget about the file.

I've spend some time researching why that's happening. I've checked what PHP docs have to offer on the topic[^3] and how
W3 describes PUT[^4]. Both were hinting, but not conclusive. I'd especially counted on PHP docs to decsribe the exact
way how to handle PUT, but it's just not there -- either it's too obvious to be mentioned or not popular enough. It
turned out that I've overinterpreted what a RESTful PUT request could/should do. I've thought that I'll literally be
able to update (upsert really) an entity (photos and all) 
with it. Not the case. Apparently the way put is supposed to work is to replace a content denoted by the request uri with 
the payload it carries. So if it's an image it'll change it to some other file, if it's an entity with 9 properties and 
the payload contains an entity with 3 properties it'll override the original with the smaller one (hence replace rather 
than update). So I guess (because I can't find stone-solid reference for this) it won't work the way I imagined 
it with multipart forms -- because that in itself suggests that it's at least 2 entities we're updating. They way my 
colleague put it is that you'd need to requests to get that data to 2 separate uri's. 

I could argue with that, because if you'd encode that very same image to a string and make it a property of that entity, 
it'd be one, inseparable thing. So the representation of the image (binary file, base-encoded string) would be 
difference between a single entity and two independent entities. Nitpicking, maybe.

Anyway onto the practical stuff. I've found several workaround for handling PUT requests in ZF2. One was about manually 
setting the request data[^1]. It doesn't help with my multipart form though. Another one was to put a hidden `_method`, 
set it to `put` and send the form as POST request[^2]. It's valid, but why bother? It still needs to send it to 
a uri that has a id in it. That in itself should be enough to tell creation from update apart. So I just send it 
as post and then do this:


    public function create($data)
    {
        $id = $this->params('id', null);
        if ($id) {
           return $this->update($id, $data);
        }
        // ...
    }

Simple and effective. Shame it doesn't work out of the box, but it's not a too terribly inconvenient either.

[^1]: [Stack post](http://stackoverflow.com/a/26676252/1105871)
[^2]: [blog post about handling put/delete in ZF2 (in polish)](http://blog.piotr.rybaltowski.pl/rest-w-zf2-metody-put-i-delete-w-formularzach/)
[^3]: [W3 method definitions](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html)
[^4]: [PHP put method support](http://php.net/manual/pl/features.file-upload.put-method.php)

[AbstractRestfulController]: http://framework.zend.com/manual/current/en/modules/zend.mvc.controllers.html#the-abstractrestfulcontroller
[PSR-7]: http://www.php-fig.org/psr/psr-7/
