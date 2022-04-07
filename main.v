module main

import voracity

fn main() {
	a := 'abcd'
	println(voracity.parse<string, string>(a, voracity.tag("ab"))?)
}
