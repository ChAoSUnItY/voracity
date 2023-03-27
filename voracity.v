module main

import voracity.complete.bytes

fn main() {
	matched, remaining := bytes.tag('K')('KEK')!
	println(matched)
	println(remaining)
}
