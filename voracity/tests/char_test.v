module tests

import voracity.complete.character

fn test_tag() {
	a_tag := character.tag('a'[0])
	inputs := ['a', 'abc']
	remains := ['', 'bc']

	for i, input in inputs {
		got, remain := a_tag(input)!

		assert got == 'a'[0]
		assert remain == remains[i]
	}
}

fn test_tag_err() {
	a_tag := character.tag('a'[0])
	inputs := [' abc', '']
	errors := inputs.map(character.new_char_parser_error(it, .tag))

	for i, input in inputs {
		a_tag(input) or { assert errors[i] == err }
	}
}

fn test_satisfy() {
	a_b_satisfy := character.satisfy(fn (b u8) bool {
		return b == 'a'[0] || b == 'b'[0]
	})
	inputs := ['abc', 'bcd']
	gots := ['a', 'b'].map(it[0])
	remains := ['bc', 'cd']

	for i, input in inputs {
		got, remain := a_b_satisfy(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_satisfy_err() {
	a_b_satisfy := character.satisfy(fn (b u8) bool {
		return b == 'a'[0] || b == 'b'[0]
	})
	inputs := ['cde', '']
	errors := inputs.map(character.new_char_parser_error(it, .tag))

	for i, input in inputs {
		a_b_satisfy(input) or { assert errors[i] == err }
	}
}

fn test_one_of() {
	a_b_c_one_of := character.one_of('abc')
	inputs := ['a', 'b', 'c', 'abc', 'bcd', 'cde']
	gots := ['a', 'b', 'c', 'a', 'b', 'c'].map(it[0])
	remains := ['', '', '', 'bc', 'cd', 'de']

	for i, input in inputs {
		got, remain := a_b_c_one_of(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_one_of_err() {
	a_b_c_one_of := character.one_of('abc')
	inputs := ['def', '']
	errors := inputs.map(character.new_char_parser_error(it, .one_of))

	for i, input in inputs {
		a_b_c_one_of(input) or { assert errors[i] == err }
	}
}

fn test_none_of() {
	a_b_c_none_of := character.none_of('abc')
	inputs := ['x', 'y', 'z', 'ijk', 'jkl', 'klm']
	gots := ['x', 'y', 'z', 'i', 'j', 'k'].map(it[0])
	remains := ['', '', '', 'jk', 'kl', 'lm']

	for i, input in inputs {
		got, remain := a_b_c_none_of(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_none_of_err() {
	a_b_c_none_of := character.none_of('abc')
	inputs := ['a', 'b', 'c', 'abc', 'bcd', 'cde']
	errors := inputs.map(character.new_char_parser_error(it, .one_of))

	for i, input in inputs {
		a_b_c_none_of(input) or { assert errors[i] == err }
	}
}

fn test_new_line() {
	inputs := ['\n', '\nabc']
	remains := ['', 'abc']

	for i, input in inputs {
		got, remain := character.new_line()(input)!

		assert got == '\n'[0]
		assert remain == remains[i]
	}
}

fn test_new_line_err() {
	inputs := ['\r\n', 'abc\n', '']
	errors := inputs.map(character.new_char_parser_error(it, .new_line))

	for i, input in inputs {
		character.new_line()(input) or { assert errors[i] == err }
	}
}

fn test_tab() {
	inputs := ['\t', '\tabc']
	remains := ['', 'abc']

	for i, input in inputs {
		got, remain := character.tab()(input)!

		assert got == '\t'[0]
		assert remain == remains[i]
	}
}

fn test_tab_err() {
	inputs := ['\n\t', 'abc\t', '']
	errors := inputs.map(character.new_char_parser_error(it, .tab))

	for i, input in inputs {
		character.new_line()(input) or { assert errors[i] == err }
	}
}

fn test_anychar() {
	inputs := ['a', 'ab', 'abc']
	remains := ['', 'b', 'bc']

	for i, input in inputs {
		got, remain := character.anychar()(input)!

		assert got == 'a'[0]
		assert remain == remains[i]
	}
}

fn test_anychar_err() {
	inputs := ['']
	errors := inputs.map(character.new_char_parser_error(it, .anychar))

	for i, input in inputs {
		character.anychar()(input) or { assert errors[i] == err }
	}
}
