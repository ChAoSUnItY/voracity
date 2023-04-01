module character

enum ErrorKind {
	char
}

[inline]
pub fn char(ch byte) CharParser {
	return fn [ch] (input string) !(byte, string) {
		return if input[0] == ch {
			ch, input[1..]
		} else {
			new_char_parser_error(input, .char)
		}
	}
}
