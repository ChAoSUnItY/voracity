module main

import voracity

fn main() {
	a := ' abcd'
	result := voracity.parse_str(a, voracity.alpha1())

	println(result.str_t<string, string>())
}
