---
layout: page
permalink: /tags/
title: Tags
---

<div>
{% for tag in site.tags %}
  <div>
    {% capture tag_name %}{{ tag | first }}{% endcapture %}
    <div id="#{{ tag_name | slugize }}"></div>

    <h3>{{ tag_name }}</h3>
    <a name="{{ tag_name | slugize }}"></a>
    {% for post in site.tags[tag_name] %}
    <article>
      <h4><a href="{{ post.url }}">{{ post.title }}</a></h4>
    </article>
    {% endfor %}
  </div>
{% endfor %}
</div>