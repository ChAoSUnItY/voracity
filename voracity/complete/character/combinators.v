module character

enum ErrorKind {
	tag
	satisfy
	one_of
}

[inline]
pub fn tag(ch u8) CharParser {
	return fn [ch] (input string) !(u8, string) {
		return if input.len > 0 && input[0] == ch {
			ch, input[1..]
		} else {
			new_char_parser_error(input, .tag)
		}
	}
}

[inline]
pub fn satisfy(predicate CharPredicate) CharParser {
	return fn [predicate] (input string) !(u8, string) {
		return if input.len > 0 && predicate(input[0]) {
			input[0], input[1..]
		} else {
			new_char_parser_error(input, .satisfy)
		}
	}
}

[inline]
pub fn one_of(chars string) CharParser {
	return one_of_u8s(chars.bytes())
}

[inline]
pub fn one_of_u8s(bytes []u8) CharParser {
	return fn [bytes] (input string) !(u8, string) {
		return if input.len > 0 && input[0] in bytes {
			input[0], input[1..]
		} else {
			new_char_parser_error(input, .one_of)
		}
	}
}

[inline]
pub fn none_of(chars string) CharParser {
	return none_of_u8s(chars.bytes())
}

pub fn none_of_u8s(bytes []u8) CharParser {
	return fn [bytes] (input string) !(u8, string) {
		return if input.len > 0 && input[0] !in bytes {
			input[0], input[1..]
		} else {
			new_char_parser_error(input, .one_of)
		}
	}
}
