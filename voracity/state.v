module voracity

import encoding.utf8 { raw_index, is_space }

pub struct State {
	input string
	wd VoidParser
mut:
	pos int
	cut int
	error Error
}

pub fn ascii_whitespace(mut state State) {
	for state.pos < state.input.len {
		match state.input[state.pos] {
			`\t`, `\n`, `\v`, `\f`, `\r`, ` ` {
				state.pos++
			}
			else {
				return
			}
		}
	}
}
