///|
pub fn parse_decimal(input : String, begin : Int32, end : Int32) -> Int32? {
  if begin == end {
    return None
  }
  let mut val = 0
  let mut i = begin
  while i < end {
    let c = input[i]
    if c >= '0' && c <= '9' {
      val = val * 10 + (c.to_int() - '0'.to_int())
    } else {
      return None
    }
    i += 1
  }
  Some(val)
}

///|
pub fn parse_hex(input : String, begin : Int32, end : Int32) -> Int32? {
  if begin == end {
    return None
  }
  let mut val = 0
  let mut i = begin
  while i < end {
    let c = input[i]
    let digit = if c >= '0' && c <= '9' {
      c.to_int() - '0'.to_int()
    } else if c >= 'a' && c <= 'f' {
      c.to_int() - 'a'.to_int() + 10
    } else if c >= 'A' && c <= 'F' {
      c.to_int() - 'A'.to_int() + 10
    } else {
      return None
    }
    val = val * 16 + digit
    i += 1
  }
  Some(val)
}
