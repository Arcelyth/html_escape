///|
using @html_escape {
  escape_text_minimal,
  escape_text,
  escape_double_quoted,
  escape_quoted,
  escape_single_quoted,
  escape_safe,
}

///|
test (b : @bench.T) {
  let plain = "Hello MoonBit 12345"
  let htmlish = "<div class=\"x\">A & B / C ' D</div>"
  let long_text = "The quick brown fox jumps over the lazy dog. <tag attr=\"1\">&</tag>"

  b.bench(name="text_minimal_plain", fn() { b.keep(escape_text_minimal(plain)) })

  b.bench(name="text_plain", fn() { b.keep(escape_text(plain)) })

  b.bench(name="double_quoted_htmlish", fn() {
    b.keep(escape_double_quoted(htmlish))
  })

  b.bench(name="single_quoted_htmlish", fn() {
    b.keep(escape_single_quoted(htmlish))
  })

  b.bench(name="quoted_htmlish", fn() { b.keep(escape_quoted(htmlish)) })

  b.bench(name="safe_htmlish", fn() { b.keep(escape_safe(htmlish)) })

  b.bench(name="safe_long_text", fn() { b.keep(escape_safe(long_text)) })
}
