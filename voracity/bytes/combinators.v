module bytes

import voracity.bytes
import voracity

enum ErrorKind {
	tag
}

pub fn tag(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		len := tag.len

		if input.len >= len && input.starts_with(tag) {
			return input[..len], input[len..]
		} else {
			return voracity.new_parse_error(input, voracity.ErrorKind(ErrorKind.tag))
		}
	}
}
