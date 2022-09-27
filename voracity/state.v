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

pub fn unicode_whitespace(mut state State) {
	for state.pos < state.input.len {
		s := raw_index(state.get(), 0)

		if !is_space(s.runes()[0]) {
			return
		}

		state.pos += s.len
	}
}

pub fn no_whitespace(mut state State) {
}

fn (state &State) get() string {
	if state.pos >= state.input.len {
		return ''
	}

	return state.input[state.pos..]
}
