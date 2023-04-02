module bytes

import voracity
import voracity.character

enum ErrorKind {
	tag
	tag_no_case
	is_not
	is_a
	take_while1
	take_while_m_n
	take_till1
	take
	take_until
	take_until1
	escaped
	crlf
	not_line_ending
	line_ending
	alpha1
	digit1
}

[inline]
pub fn tag(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		len := tag.len

		return if input.len >= len && input.starts_with(tag) {
			input[..len], input[len..]
		} else {
			new_bytes_parser_error(input, .tag)
		}
	}
}

[inline]
pub fn tag_no_case(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		len := tag.len

		return if input.len >= len && input[..len].to_lower() == tag.to_lower() {
			input[..len], input[len..]
		} else {
			new_bytes_parser_error(input, .tag_no_case)
		}
	}
}

[inline]
pub fn is_not(arr string) BytesParser {
	return fn [arr] (input string) !(string, string) {
		if input.len == 0 {
			return new_bytes_parser_error(input, .is_not)
		}

		pat := arr.bytes()
		mut idx := 0

		for idx < input.len {
			if input[idx] in pat {
				return input[..idx], input[idx..]
			} else {
				idx++
			}
		}

		return '', input
	}
}

[inline]
pub fn is_a(arr string) BytesParser {
	return fn [arr] (input string) !(string, string) {
		if input.len == 0 {
			return new_bytes_parser_error(input, .is_a)
		}

		pat := arr.bytes()
		mut idx := 0

		for idx < input.len {
			if input[idx] !in pat {
				break
			} else {
				idx++
			}
		}

		return input[..idx], input[idx..]
	}
}

[inline]
pub fn take_while(predicate BytesPredicate) BytesParser {
	return fn [predicate] (input string) !(string, string) {
		mut idx := 0

		for idx < input.len {
			if !predicate(input[idx]) {
				break
			} else {
				idx++
			}
		}

		return input[..idx], input[idx..]
	}
}

[inline]
pub fn take_while1(predicate BytesPredicate) BytesParser {
	return fn [predicate] (input string) !(string, string) {
		mut idx := 0

		for idx < input.len {
			if !predicate(input[idx]) {
				break
			} else {
				idx++
			}
		}

		return if idx == 0 {
			new_bytes_parser_error(input, .take_while1)
		} else {
			input[..idx], input[idx..]
		}
	}
}

[inline]
pub fn take_while_m_n(predicate BytesPredicate, m int, n int) BytesParser {
	return fn [predicate, m, n] (input string) !(string, string) {
		mut idx := 0

		for idx < input.len && idx < n {
			if !predicate(input[idx]) {
				break
			} else {
				idx++
			}
		}

		return if idx >= m && idx <= n {
			input[..idx], input[idx..]
		} else {
			new_bytes_parser_error(input, .take_while_m_n)
		}
	}
}

[inline]
pub fn take_till(predicate BytesPredicate) BytesParser {
	return fn [predicate] (input string) !(string, string) {
		mut idx := 0

		for idx < input.len {
			if predicate(input[idx]) {
				break
			} else {
				idx++
			}
		}

		return input[..idx], input[idx..]
	}
}

[inline]
pub fn take_till1(predicate BytesPredicate) BytesParser {
	return fn [predicate] (input string) !(string, string) {
		mut idx := 0

		for idx < input.len {
			if predicate(input[idx]) {
				break
			} else {
				idx++
			}
		}

		return if idx == 0 {
			new_bytes_parser_error(input, .take_till1)
		} else {
			input[..idx], input[idx..]
		}
	}
}

[inline]
pub fn take(count int) BytesParser {
	return fn [count] (input string) !(string, string) {
		return if input.len < count {
			new_bytes_parser_error(input, .take)
		} else {
			input[..count], input[count..]
		}
	}
}

[inline]
pub fn take_until(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		tag_len := tag.len
		mut idx := 0

		for idx < input.len {
			if idx + tag_len <= input.len && input[idx..idx + tag_len] == tag {
				return input[..idx], input[idx..]
			} else {
				idx++
			}
		}

		return new_bytes_parser_error(input, .take_until)
	}
}

[inline]
pub fn take_until1(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		tag_len := tag.len
		mut idx := 0

		for idx < input.len {
			if idx + tag_len <= input.len && input[idx..idx + tag_len] == tag {
				break
			} else {
				idx++
			}
		}

		return if idx == 0 {
			new_bytes_parser_error(input, .take_until1)
		} else {
			input[..idx], input[idx..]
		}
	}
}

[inline]
pub fn escaped(normal voracity.IBytesParser, control_char u8, escapable voracity.IBytesParser) BytesParser {
	return fn [normal, control_char, escapable] (input string) !(string, string) {
		mut idx := 0

		for idx < input.len {
			current_len := input.len - idx

			if _, remain := normal(input) {
				if remain.len == 0 {
					// No remaining
					return input, ''
				}
				if remain.len == current_len {
					// No consumption occured
					return input[..idx], input[idx..]
				} else {
					idx++
				}
			} else {
				if input[idx] == control_char {
					if idx + 1 < input.len {
						next_char := input[idx + 1].ascii_str()
						_, remain := escapable(next_char)!

						if remain.len == 0 {
							// No remaining
							return input, ''
						} else {
							idx += 2
						}
					} else {
						// Invalid escape (out of bound)
						return new_bytes_parser_error(input, .escaped)
					}
				} else {
					if idx == 0 {
						return new_bytes_parser_error(input, .escaped)
					} else {
						return input, ''
					}
				}
			}
		}

		return input[..idx], input[idx..]
	}
}

[inline]
pub fn crlf() BytesParser {
	return crlf_
}

[inline]
fn crlf_(input string) !(string, string) {
	return if input.len >= 2 && input[..2] == '\r\n' {
		input[..2], input[2..]
	} else {
		new_bytes_parser_error(input, .crlf)
	}
}

[inline]
pub fn not_line_ending() BytesParser {
	return not_line_ending_
}

fn not_line_ending_(input string) !(string, string) {
	mut idx := 0

	for idx < input.len {
		if input[idx] == '\r'[0] {
			if idx + 1 < input.len && input[idx + 1] == '\n'[0] {
				break
			} else {
				return new_bytes_parser_error(input, .not_line_ending)
			}
		} else if input[idx] == '\n'[0] {
			break
		} else {
			idx++
		}
	}

	return input[..idx], input[idx..]
}

[inline]
pub fn line_ending() BytesParser {
	return line_ending_
}

[inline]
fn line_ending_(input string) !(string, string) {
	return if input.len > 0 && input[0] == '\r'[0] {
		if input.len > 1 && input[1] == '\n'[0] {
			input[..2], input[2..]
		} else {
			new_bytes_parser_error(input, .line_ending)
		}
	} else if input[0] == '\n'[0] {
		input[..1], input[1..]
	} else {
		new_bytes_parser_error(input, .line_ending)
	}
}

[inline]
fn alpha0() BytesParser {
	return alpha0_
}

fn alpha0_(input string) !(string, string) {
	mut idx := 0

	for idx < input.len {
		if character.is_alphabetic(input[idx]) {
			idx++
		} else {
			break
		}
	}

	return input[..idx], input[idx..]
}

[inline]
fn alpha1() BytesParser {
	return alpha1_
}

fn alpha1_(input string) !(string, string) {
	mut idx := 0

	for idx < input.len {
		if character.is_alphabetic(input[idx]) {
			idx++
		} else {
			break
		}
	}

	return if idx == 0 {
		new_bytes_parser_error(input, .alpha1)
	} else {
		input[..idx], input[idx..]
	}
}

[inline]
fn digit0() BytesParser {
	return digit0_
}

fn digit0_(input string) !(string, string) {
	mut idx := 0

	for idx < input.len {
		if character.is_digit(input[idx]) {
			idx++
		} else {
			break
		}
	}

	return input[..idx], input[idx..]
}

[inline]
fn digit1() BytesParser {
	return digit1_
}

fn digit1_(input string) !(string, string) {
	mut idx := 0

	for idx < input.len {
		if character.is_digit(input[idx]) {
			idx++
		} else {
			break
		}
	}

	return if idx == 0 {
		new_bytes_parser_error(input, .digit1)
	} else {
		input[..idx], input[idx..]
	}
}
