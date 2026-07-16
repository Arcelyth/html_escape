# html_escape

A HTML escaping and unescaping library for MoonBit.

## Examples

Escaping: 
```moonbit nocheck
assert_eq(escape_quoted("\"'&<>"), "&quot;&#x27;&amp;&lt;&gt;")
assert_eq(escape_safe("<script>alert('xss')</script>"), "&lt;script&gt;alert(&#x27;xss&#x27;)&lt;&#x2F;script&gt;")
```

Unescaping:
```moonbit nocheck
assert_eq(unescape("&lt;div&gt;hello&amp;world&lt;/div&gt;"), "<div>hello&world</div>")
```

## License

MIT License
