module main

import voracity

fn main() {
	a := 'abcd'
	result := voracity.parse_str(a, voracity.bytes(`a`.bytes()))

	println(result.str_t<string, string>())
}
