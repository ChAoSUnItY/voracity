module bytes

import voracity

enum ErrorKind {
	tag
	tag_no_case
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

pub fn tag_no_case(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		len := tag.len

		if input.len >= len && input[..len].to_lower() == tag.to_lower() {
			return input[..len], input[len..]
		} else {
			return voracity.new_parse_error(input, voracity.ErrorKind(ErrorKind.tag_no_case))
		}
	}
}
