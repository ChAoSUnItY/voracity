module character

import voracity { CharParser, CharPredicate }

pub enum ErrorKind {
	tag
	satisfy
	one_of
	new_line
	tab
	anychar
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

[inline]
pub fn none_of_u8s(bytes []u8) CharParser {
	return fn [bytes] (input string) !(u8, string) {
		return if input.len > 0 && input[0] !in bytes {
			input[0], input[1..]
		} else {
			new_char_parser_error(input, .one_of)
		}
	}
}

[inline]
pub fn new_line() CharParser {
	return new_line_
}

[inline]
fn new_line_(input string) !(u8, string) {
	return if input.len > 0 && input[0] == '\n'[0] {
		'\n'[0], input[1..]
	} else {
		new_char_parser_error(input, .new_line)
	}
}

[inline]
pub fn tab() CharParser {
	return tab_
}

[inline]
fn tab_(input string) !(u8, string) {
	return if input.len > 0 && input[0] == '\t'[0] {
		'\t'[0], input[1..]
	} else {
		new_char_parser_error(input, .tab)
	}
}

[inline]
pub fn anychar() CharParser {
	return anychar_
}

[inline]
fn anychar_(input string) !(u8, string) {
	return if input.len > 0 {
		input[0], input[1..]
	} else {
		new_char_parser_error(input, .anychar)
	}
}
