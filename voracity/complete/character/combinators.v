module character

enum ErrorKind {
	tag
}

[inline]
pub fn tag(ch byte) CharParser {
	return fn [ch] (input string) !(byte, string) {
		return if input.len > 0 && input[0] == ch {
			ch, input[1..]
		} else {
			new_char_parser_error(input, .tag)
		}
	}
}
