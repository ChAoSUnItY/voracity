module main

import voracity.bytes

fn main() {
	matched, remaining := bytes.tag('K')('KEK')!
	println(matched)
	println(remaining)
}
