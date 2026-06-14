///|
/// Defines the HTML escaping strategy.
///
/// Different contexts in HTML require different escaping rules.
/// For example, plain text only needs to escape `<` and `&`,
/// while quoted attributes must also escape quotation marks.
pub(all) enum EscapeMode {
  /// Escape `&` and `<`.
  TextMinimal
  /// Escape `&`, `<`, and `>`.
  Text
  /// Escape characters required inside double-quoted attributes:
  /// `&`, `<`, `>`, and `"`.
  DoubleQuoted
  /// Escape characters required inside single-quoted attributes:
  /// `&`, `<`, `>`, and `'`.
  SingleQuoted
  /// Escape all characters required inside quoted attributes:
  /// `&`, `<`, `>`, `"`, and `'`.
  Quoted
  /// Escape all HTML-sensitive characters including `/`.
  Safe
}

///|
/// Returns the HTML escape sequence corresponding to the given character under the specified escape mode.
fn escape_char(mode : EscapeMode, c : UInt16) -> Option[String] {
  match mode {
    EscapeMode::TextMinimal => match c {
      '&' => Some("&amp;")
      '<' => Some("&lt;")
      _ => None
    }
    EscapeMode::Text => match c {
      '&' => Some("&amp;")
      '<' => Some("&lt;")
      '>' => Some("&gt;")
      _ => None
    }
    EscapeMode::DoubleQuoted => match c {
      '&' => Some("&amp;")
      '<' => Some("&lt;")
      '>' => Some("&gt;")
      '"' => Some("&quot;")
      _ => None
    }
    EscapeMode::SingleQuoted => match c {
      '&' => Some("&amp;")
      '<' => Some("&lt;")
      '>' => Some("&gt;")
      '\'' => Some("&#x27;")
      _ => None
    }
    EscapeMode::Quoted => match c {
      '&' => Some("&amp;")
      '<' => Some("&lt;")
      '>' => Some("&gt;")
      '"' => Some("&quot;")
      '\'' => Some("&#x27;")
      _ => None
    }
    EscapeMode::Safe => match c {
      '&' => Some("&amp;")
      '<' => Some("&lt;")
      '>' => Some("&gt;")
      '"' => Some("&quot;")
      '\'' => Some("&#x27;")
      '/' => Some("&#x2F;")
      _ => None
    }
  }
}

///| 
fn first_escape_pos(text : String, mode : EscapeMode) -> Int {
  let len = text.length()
  let mut i = 0
  while i < len {
    match escape_char(mode, text[i]) {
      Some(_) => return i
      None => ()
    }
    i += 1
  }
  -1
}

///|
/// Escapes a string according to the specified HTML escaping mode.
pub fn escape(text : String, mode : EscapeMode) -> String {
  let first = first_escape_pos(text, mode) 
  if first < 0 {
    return text
  }
  let len = text.length()
  let buf = StringBuilder::new(size_hint=len+16)
  
  buf.write_stringview(text[0:first])
  
  let mut start = first
  let mut i = first
  while i < len {
    let c = text[i]
    match escape_char(mode, c) {
      Some(en) => {
        if i > start {
          buf.write_stringview(text[start:i])
        }
        buf.write_stringview(en)
        start = i + 1
      }
      None => ()
    }
    i += 1
  }
  
  if i > start {
    buf.write_stringview(text[start:i])
  }
  
  buf.to_string()
}


///|
/// Escapes a string for use in HTML text content using the
/// minimal escaping rules.
///
/// The following characters are escaped:
///
/// - `&` → `&amp;`
/// - `<` → `&lt;`
pub fn escape_text_minimal(text : String) -> String {
  escape(text, EscapeMode::TextMinimal)
}

///|
/// Escapes a string for use in normal HTML text content.
///
/// The following characters are escaped:
///
/// - `&` → `&amp;`
/// - `<` → `&lt;`
/// - `>` → `&gt;`
pub fn escape_text(text : String) -> String {
  escape(text, EscapeMode::Text)
}

///|
/// Escapes a string for use inside a double-quoted HTML attribute.
///
/// The following characters are escaped:
///
/// - `&` → `&amp;`
/// - `<` → `&lt;`
/// - `>` → `&gt;`
/// - `"` → `&quot;`
pub fn escape_double_quoted(text : String) -> String {
  escape(text, EscapeMode::DoubleQuoted)
}

///|
/// Escapes a string for use inside a single-quoted HTML attribute.
///
/// The following characters are escaped:
///
/// - `&` → `&amp;`
/// - `<` → `&lt;`
/// - `>` → `&gt;`
/// - `'` → `&#x27;`
pub fn escape_single_quoted(text : String) -> String {
  escape(text, EscapeMode::SingleQuoted)
}

///|
/// Escapes a string for use inside a quoted HTML attribute.
///
/// The following characters are escaped:
///
/// - `&` → `&amp;`
/// - `<` → `&lt;`
/// - `>` → `&gt;`
/// - `"` → `&quot;`
/// - `'` → `&#x27;`
pub fn escape_quoted(text : String) -> String {
  escape(text, EscapeMode::Quoted)
}

///|
/// Escapes a string using the safest HTML escaping strategy.
///
/// The following characters are escaped:
///
/// - `&` → `&amp;`
/// - `<` → `&lt;`
/// - `>` → `&gt;`
/// - `"` → `&quot;`
/// - `'` → `&#x27;`
/// - `/` → `&#x2F;
pub fn escape_safe(text : String) -> String {
  escape(text, EscapeMode::Safe)
}
