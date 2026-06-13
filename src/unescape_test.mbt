///|
test "unescape empty string" {
  assert_eq(
    unescape(""),
    ""
  )
}

///|
test "unescape plain text" {
  assert_eq(
    unescape("hello world"),
    "hello world"
  )
}

///|
test "unescape amp" {
  assert_eq(
    unescape("&amp;"),
    "&"
  )
}

///|
test "unescape lt" {
  assert_eq(
    unescape("&lt;"),
    "<"
  )
}

///|
test "unescape gt" {
  assert_eq(
    unescape("&gt;"),
    ">"
  )
}

///|
test "unescape quot" {
  assert_eq(
    unescape("&quot;"),
    "\""
  )
}

///|
test "unescape apos" {
  assert_eq(
    unescape("&apos;"),
    "'"
  )
}
