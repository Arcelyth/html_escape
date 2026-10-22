///|
using @html_escape {
  escape_text_minimal,
  escape_text,
  escape_safe,
  escape_quoted,
  escape_double_quoted,
  escape_single_quoted,
}

///|
test "escape_text_minimal empty" {
  assert_eq(escape_text_minimal(""), "")
}

///|
test "escape_text_minimal no escape" {
  assert_eq(escape_text_minimal("hello world"), "hello world")
}

///|
test "escape_text_minimal ampersand" {
  assert_eq(escape_text_minimal("a & b"), "a &amp; b")
}

///|
test "escape_text_minimal less than" {
  assert_eq(escape_text_minimal("1 < 2"), "1 &lt; 2")
}

///|
test "escape_text_minimal multiple" {
  assert_eq(escape_text_minimal("a & b < c"), "a &amp; b &lt; c")
}

///|
test "escape_text greater than" {
  assert_eq(escape_text("1 > 2"), "1 &gt; 2")
}

///|
test "escape_text all" {
  assert_eq(escape_text("<div>a & b</div>"), "&lt;div&gt;a &amp; b&lt;/div&gt;")
}

///|
test "escape_double_quoted quote" {
  assert_eq(escape_double_quoted("hello \"world\""), "hello &quot;world&quot;")
}

///|
test "escape_double_quoted html" {
  assert_eq(
    escape_double_quoted("\" onclick=\"alert(1)"),
    "&quot; onclick=&quot;alert(1)",
  )
}

///|
test "escape_single_quoted quote" {
  assert_eq(escape_single_quoted("it's fine"), "it&#x27;s fine")
}

///|
test "escape_single_quoted html" {
  assert_eq(
    escape_single_quoted("' onclick='alert(1)"),
    "&#x27; onclick=&#x27;alert(1)",
  )
}

///|
test "escape_quoted double quote" {
  assert_eq(escape_quoted("\""), "&quot;")
}

///|
test "escape_quoted single quote" {
  assert_eq(escape_quoted("'"), "&#x27;")
}

///|
test "escape_quoted mixed" {
  assert_eq(escape_quoted("\"'&<>"), "&quot;&#x27;&amp;&lt;&gt;")
}

///|
test "escape_safe slash" {
  assert_eq(escape_safe("/"), "&#x2F;")
}

///|
test "escape_safe script tag" {
  assert_eq(escape_safe("</script>"), "&lt;&#x2F;script&gt;")
}

///|
test "escape unicode chinese" {
  assert_eq(escape_text("你好 < 世界"), "你好 &lt; 世界")
}

///|
test "escape unicode emoji" {
  assert_eq(escape_text("😀 < 😎"), "😀 &lt; 😎")
}

///|
test "escape consecutive ampersands" {
  assert_eq(escape_text("&&&"), "&amp;&amp;&amp;")
}

///|
test "escape consecutive tags" {
  assert_eq(escape_text("<<<>>>"), "&lt;&lt;&lt;&gt;&gt;&gt;")
}

///|
test "xss script" {
  assert_eq(
    escape_safe("<script>alert('xss')</script>"),
    "&lt;script&gt;alert(&#x27;xss&#x27;)&lt;&#x2F;script&gt;",
  )
}

///|
test "xss img" {
  assert_eq(
    escape_quoted("\" onerror=\"alert(1)"),
    "&quot; onerror=&quot;alert(1)",
  )
}

///|
test "all reserved chars" {
  assert_eq(escape_safe("&<>\"'/"), "&amp;&lt;&gt;&quot;&#x27;&#x2F;")
}
