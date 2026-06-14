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
