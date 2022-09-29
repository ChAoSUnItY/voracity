module main

import voracity

fn main() {
	println('Hello World!')
	test()!
}

fn test() ! {
	return voracity.ParseError {
		code: 1,
		msg: 'kek'
	}.err()
}
