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

pub fn (mut state State) advance(i int) {
	state.pos += i
}

pub fn (state &State) get() string {
	if state.pos >= state.input.len {
		return ''
	}

	return state.input[state.pos..]
}

pub fn (state &State) preview(len int) string {
	if state.pos >= state.input.len {
		return ''
	}

	get := state.get()

	if get.len >= len {
		return get[..len]
	}

	return get
}

pub fn (mut state State) error_here(expected string) {
	state.error.pos = state.pos
	state.error.expected = expected
}

pub fn (mut state State) recover() {
	state.error.expected = ''
}

pub fn (state &State) errored() bool {
	return state.error.expected != ''
}
