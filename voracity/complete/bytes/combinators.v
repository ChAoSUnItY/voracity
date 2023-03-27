module bytes

import voracity

enum ErrorKind {
	tag
	tag_no_case
	is_not
}

pub fn tag(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		len := tag.len

		if input.len >= len && input.starts_with(tag) {
			return input[..len], input[len..]
		} else {
			return new_bytes_parser_error(input, .tag)
		}
	}
}

pub fn tag_no_case(tag string) BytesParser {
	return fn [tag] (input string) !(string, string) {
		len := tag.len

		if input.len >= len && input[..len].to_lower() == tag.to_lower() {
			return input[..len], input[len..]
		} else {
			return new_bytes_parser_error(input, .tag_no_case)
		}
	}
}

pub fn is_not(arr string) BytesParser {
	return fn [arr] (input string) !(string, string) {
		if input.len == 0 {
			return new_bytes_parser_error(input, .is_not)
		}

		pat := arr.bytes()
		mut idx := 0

		for idx < input.len {
			if input[idx] in pat
			{
				return input[..idx], input[idx..]
			} else {
				idx++
			}
		}

		return '', input
	}
}
