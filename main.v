module main

import voracity

fn main() {
	a := 'abcd'
	result := voracity.parse_str(a, voracity.runes([`a`]))

	println(result.str_t<string, string>())
}
