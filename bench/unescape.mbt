///|
using @html_escape {unescape}

///|
test (b : @bench.T) {
  let plain = "The quick brown fox jumps over the lazy dog"

  let named = "&lt;div&gt;Tom &amp; Jerry&lt;/div&gt;"

  let numeric = "&#60;div&#62;&#38;&#160;&#60;/div&#62;"

  let hex = "&#x3C;div&#x3E;&#x26;&#xA0;&#x3C;/div&#x3E;"

  let legacy = "&ltdiv&gtTom &amp Jerry&lt/div&gt"

  let mixed =
    #|    &lt;div class=&quot;container&quot;&gt;
    #|      Tom &amp; Jerry &#38; Friends
    #|      &#x1F600;
    #|      &nbsp;
    #|    &lt;/div&gt;
    #|    

  let large = named.repeat(1000)

  b.bench(name="unescape_plain", fn() { b.keep(unescape(plain)) })

  b.bench(name="unescape_named", fn() { b.keep(unescape(named)) })

  b.bench(name="unescape_numeric", fn() { b.keep(unescape(numeric)) })

  b.bench(name="unescape_hex", fn() { b.keep(unescape(hex)) })

  b.bench(name="unescape_legacy", fn() { b.keep(unescape(legacy)) })

  b.bench(name="unescape_mixed", fn() { b.keep(unescape(mixed)) })

  b.bench(name="unescape_large", fn() { b.keep(unescape(large)) })
}
