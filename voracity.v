module main

import voracity.complete.bytes
import voracity.complete.character

fn main() {
	matched, remaining := character.char('K'[0])('KEK')!
	println(matched)
	println(remaining)
}
