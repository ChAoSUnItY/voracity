module voracity

import encoding.utf8 { raw_index, is_space }

[noinit]
pub struct State {
	input string
	ws VoidParser
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

pub fn new_state(input string) State {
	return State{
		input: input,
		ws: unicode_whitespace
	}
}

fn (state &State) get() string {
	if state.pos >= state.input.len {
		return ''
	}

	return state.input[state.pos..]
}
