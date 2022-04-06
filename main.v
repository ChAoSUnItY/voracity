module main

import voracity

fn main() {
	a := 'abcd'
	println(voracity.parse(a, voracity.tag("ab"))?.destruct())
}
