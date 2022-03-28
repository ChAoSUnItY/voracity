module main

import voracity

fn main() {
	a := "abcd"
	b := voracity.parse_str(a, voracity.multispace0())
	
	println(b.str_t<string, string>())
}
