module bytes

enum ErrorKind {
	tag
	tag_no_case
	is_not
	is_a
	take_while1
	take_while_m_n
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
