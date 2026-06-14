///|
test "unescape empty string" {
  assert_eq(unescape(""), "")
}

///|
test "unescape plain text" {
  assert_eq(unescape("hello world"), "hello world")
}

///|
test "unescape amp" {
  assert_eq(unescape("&amp;"), "&")
}

///|
test "unescape lt" {
  assert_eq(unescape("&lt;"), "<")
}

///|
test "unescape gt" {
  assert_eq(unescape("&gt;"), ">")
}

///|
test "unescape quot" {
  assert_eq(unescape("&quot;"), "\"")
}

///|
test "unescape apos" {
  assert_eq(unescape("&apos;"), "'")
}

///|
test "unescape multiple named entities" {
  assert_eq(unescape("&lt;div&gt;hello&amp;world&lt;/div&gt;"), "<div>hello&world</div>")
}

///|
test "unescape decimal entity" {
  assert_eq(unescape("&#65;"), "A")
}

///|
test "unescape decimal entity unicode" {
  assert_eq(unescape("&#233;"), "é")
}

///|
test "unescape decimal emoji" {
  assert_eq(unescape("&#128512;"), "😀")
}

///|
test "unescape hex entity" {
  assert_eq(unescape("&#x41;"), "A")
}

///|
test "unescape hex lowercase" {
  assert_eq(unescape("&#x1f600;"), "😀")
}

///|
test "unescape hex uppercase" {
  assert_eq(unescape("&#X1F600;"), "😀")
}

///|
test "unescape mixed entities" {
  assert_eq(unescape("&lt;&#65;&#x42;&gt;"), "<AB>")
}

///|
test "unknown named entity" {
  assert_eq(unescape("&NotExist;"), "&NotExist;")
}

///|
test "invalid decimal entity" {
  assert_eq(unescape("&#abc;"), "&#abc;")
}

///|
test "invalid decimal empty" {
  assert_eq(unescape("&#;"), "&#;")
}

///|
test "invalid hex entity" {
  assert_eq(unescape("&#xGG;"), "&#xGG;")
}

///|
test "invalid hex empty" {
  assert_eq(unescape("&#x;"), "&#x;")
}

///|
test "named entity without semicolon" {
  assert_eq(unescape("&amp"), "&amp")
}

///|
test "decimal entity without semicolon" {
  assert_eq(unescape("&#38"), "&#38")
}

///|
test "hex entity without semicolon" {
  assert_eq(unescape("&#x26"), "&#x26")
}

///|
test "entity at beginning" {
  assert_eq(unescape("&amp;abc"), "&abc")
}

///|
test "entity at end" {
  assert_eq(unescape("abc&amp;"), "abc&")
}

///|
test "adjacent entities" {
  assert_eq(unescape("&lt;&gt;&amp;"), "<>&")
}

///|
test "unescape html fragment" {
  assert_eq(unescape("&lt;script&gt;alert(1)&lt;/script&gt;"), "<script>alert(1)</script>")
}

///|
test "unescape nbsp" {
  assert_eq(unescape("&nbsp;"), "\u{00A0}")
}

///|
test "unescape copy" {
  assert_eq(unescape("&copy;"), "©")
}

///|
test "unescape euro" {
  assert_eq(unescape("&euro;"), "€")
}

///|
test "unescape trade" {
  assert_eq(unescape("&trade;"), "™")
}

///|
test "many entities" {
  assert_eq(unescape("&amp;&amp;&amp;&amp;&amp;"), "&&&&&")
}

///|
test "astral unicode entity" {
  assert_eq(unescape("&#x1F9D0;"), "🧐")
}
