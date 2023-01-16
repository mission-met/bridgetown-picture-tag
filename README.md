# Bridgetown Picture Tag

Heavily inspired by https://rbuchberger.github.io/jekyll_picture_tag/ and a work in progress...

This

1. Install

2. Write this: `{% picture /assets/images/test.jpg %} <!-- liquid -->`
Or this: `<%= picture "/assets/images/test.jpg" %> <!-- erb -->`

3. Get this:

```html
<!-- Formatted for readability -->

<picture>
  <source
    type="image/jxl"
    srcset="
      /generated/test-400-195f7d192.jxl   400w,
      /generated/test-600-195f7d192.jxl   600w,
      /generated/test-800-195f7d192.jxl   800w,
      /generated/test-1000-195f7d192.jxl 1000w
    ">
  <source
    type="image/webp"
    srcset="
      /generated/test-400-195f7d192.webp   400w,
      /generated/test-600-195f7d192.webp   600w,
      /generated/test-800-195f7d192.webp   800w,
      /generated/test-1000-195f7d192.webp 1000w
    ">
  <source
    type="image/jpeg"
    srcset="
      /generated/test-400-195f7d.jpg   400w,
      /generated/test-600-195f7d.jpg   600w,
      /generated/test-800-195f7d.jpg   800w,
      /generated/test-1000-195f7d.jpg 1000w
    ">
  <img src="/generated/test-800-195f7dGUW.jpg">
</picture>
```

> "That's super cool, but what if I only want jxl and jpeg?"

## TODO


> "That's neat. Got any other tricks?"

Just a few...
