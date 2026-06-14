///|
enum UnescapeState {
  Normal
  AfterAmp
  Named
  AfterHash
  Decimal
  AfterHexPrefix
  Hex
} derive(Eq)

///|
fn compare_entity_range(entity : String, input : String, begin : Int, end : Int) -> Int {
  let elen = entity.length()
  let ilen = end - begin
  let n = if elen < ilen { elen } else { ilen }
  let mut i = 0

  while i < n {
    let a = entity[i]
    let b = input[begin + i]
    if a < b { return -1 }
    if a > b { return 1 }
    i += 1
  }

  if elen < ilen { -1 } else if elen > ilen { 1 } else { 0 }
}

///|
fn find_named_entity(input : String, begin : Int, end : Int) -> Option[String] {
  let mut left = 0
  let mut right = html_entities.length()

  while left < right {
    let mid = (left + right) / 2
    let (name, value) = html_entities[mid]
    let cmp = compare_entity_range(name, input, begin, end)

    if cmp == 0 {
      return Some(value)
    }

    if cmp < 0 {
      left = mid + 1
    } else {
      right = mid
    }
  }

  None
}

///|
fn resolve_legacy_entity(input: String, begin: Int, end: Int) -> Option[String] {
  let len = end - begin
  if len == 2 {
    let s = input[begin:end]
    if s == "lt" { return Some("<") }
    if s == "gt" { return Some(">") }
  } else if len == 3 {
    if input[begin:end] == "amp" { return Some("&") }
  } else if len == 4 {
    let s = input[begin:end]
    if s == "quot" { return Some("\"") }
    if s == "apos" { return Some("'") }
    if s == "nbsp" { return Some("\u00A0") }
  }
  None
}

///|
/// Decodes HTML entities contained in a string.
///
/// Supported entity forms:
///
/// Named entities:
/// - `&amp;`
/// - `&lt;`
/// - `&gt;`
/// - and all entries contained in `html_entities`
///
/// Decimal numeric entities:
/// - `&#38;`
/// - `&#160;`
///
/// Hexadecimal numeric entities:
/// - `&#x26;`
/// - `&#XA0;`
///
/// Legacy entities without semicolons:
/// - `&amp`
/// - `&lt`
/// - `&gt`
/// - `&quot`
/// - `&apos`
/// - `&nbsp`
pub fn unescape(text : String) -> String {
  let len = text.length()
  let mut state = UnescapeState::Normal
  let mut entity_start = 0
  let mut copy_start = 0
  let mut i = 0
  let mut found = false
  let buf = StringBuilder::new(size_hint=len)

  let flush_text = fn(end_idx: Int) {
    if end_idx > copy_start {
      buf.write(text[copy_start:end_idx])
    }
  }

  while i < len {
    let c = text[i]

    match state {
      UnescapeState::Normal => {
        if c == '&' {
          entity_start = i
          state = UnescapeState::AfterAmp
        }
      }

      UnescapeState::AfterAmp => {
        match c {
          '#' => state = UnescapeState::AfterHash
          ';' => state = UnescapeState::Normal
          '&' => { entity_start = i }
          _ => state = UnescapeState::Named
        }
      }

      UnescapeState::Named => {
        if c == ';' {
          match find_named_entity(text, entity_start + 1, i) {
            Some(decoded) => {
              found = true
              flush_text(entity_start)
              buf.write_string(decoded)
              copy_start = i + 1
            }
            None => ()
          }
          state = UnescapeState::Normal
        } else if c == '&' {
          match resolve_legacy_entity(text, entity_start + 1, i) {
            Some(decoded) => {
              found = true
              flush_text(entity_start)
              buf.write_string(decoded)
              copy_start = i
            }
            None => ()
          }
          entity_start = i
          state = UnescapeState::AfterAmp
        } else if !((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) {
          match resolve_legacy_entity(text, entity_start + 1, i) {
            Some(decoded) => {
              found = true
              flush_text(entity_start)
              buf.write_string(decoded)
              copy_start = i
            }
            None => ()
          }
          state = UnescapeState::Normal
        }
      }

      UnescapeState::AfterHash => {
        match c {
          'x' | 'X' => state = UnescapeState::AfterHexPrefix
          ';' => state = UnescapeState::Normal
          '&' => { entity_start = i; state = UnescapeState::AfterAmp }
          _ => {
            if c >= '0' && c <= '9' { state = UnescapeState::Decimal } 
            else { state = UnescapeState::Normal }
          }
        }
      }

      UnescapeState::Decimal => {
        if c == ';' {
          match parse_decimal(text, entity_start + 2, i) {
            Some(value) => {
              match Int::to_char(value) {
                Some(ch) => {
                  found = true
                  flush_text(entity_start)
                  buf.write_char(ch)
                  copy_start = i + 1
                }
                None => ()
              }
            }
            None => ()
          }
          state = UnescapeState::Normal
        } else if !(c >= '0' && c <= '9') {
          state = UnescapeState::Normal
        }
      }

      UnescapeState::AfterHexPrefix => {
        if c == ';' {
          state = UnescapeState::Normal
        } else if c == '&' {
          entity_start = i
          state = UnescapeState::AfterAmp
        } else if (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F') {
          state = UnescapeState::Hex
        } else {
          state = UnescapeState::Normal
        }
      }

      UnescapeState::Hex => {
        if c == ';' {
          match parse_hex(text, entity_start + 3, i) {
            Some(value) => {
              match Int::to_char(value) {
                Some(ch) => {
                  found = true
                  flush_text(entity_start)
                  buf.write_char(ch)
                  copy_start = i + 1
                }
                None => ()
              }
            }
            None => ()
          }
          state = UnescapeState::Normal
        } else if !((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')) {
          state = UnescapeState::Normal
        }
      }
    }
    i += 1
  }

  if !found {
    return text
  }

  if state == UnescapeState::Named {
    match resolve_legacy_entity(text, entity_start + 1, len) {
      Some(decoded) => {
        flush_text(entity_start)
        buf.write_string(decoded)
        copy_start = len
      }
      None => ()
    }
  }

  flush_text(len)

  buf.to_string()
}
