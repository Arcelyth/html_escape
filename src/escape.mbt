///|
pub(all) enum EscapeMode {
  TextMinimal
  Text
  DoubleQuoted
  SingleQuoted
  Quoted
  Safe
}

///|
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
pub fn escape_text_minimal(text : String) -> String {
  escape(text, EscapeMode::TextMinimal)
}

///|
pub fn escape_text(text : String) -> String {
  escape(text, EscapeMode::Text)
}

///|
pub fn escape_double_quoted(text : String) -> String {
  escape(text, EscapeMode::DoubleQuoted)
}

///|
pub fn escape_single_quoted(text : String) -> String {
  escape(text, EscapeMode::SingleQuoted)
}

///|
pub fn escape_quoted(text : String) -> String {
  escape(text, EscapeMode::Quoted)
}

///|
pub fn escape_safe(text : String) -> String {
  escape(text, EscapeMode::Safe)
}
