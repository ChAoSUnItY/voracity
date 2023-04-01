module character

fn test_tag() {
	a_tag := tag('a'[0])
	inputs := ['a', 'abc']
	remains := ['', 'bc']

	for i, input in inputs {
		got, remain := a_tag(input)!

		assert got == 'a'[0]
		assert remain == remains[i]
	}
}

fn test_tag_err() {
	a_tag := tag('a'[0])
	inputs := [' abc', '']
	errors := inputs.map(new_char_parser_error(it, .tag))

	for i, input in inputs {
		a_tag(input) or { assert errors[i] == err }
	}
}

fn test_satisfy() {
	a_b_satisfy := satisfy(fn (b byte) bool {
		return b == 'a'[0] || b == 'b'[0]
	})
	inputs := ['abc', 'bcd']
	gots := ['a'[0], 'b'[0]]
	remains := ['bc', 'cd']

	for i, input in inputs {
		got, remain := a_b_satisfy(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_satisfy_err() {
	a_b_satisfy := satisfy(fn (b byte) bool {
		return b == 'a'[0] || b == 'b'[0]
	})
	inputs := ['cde', '']
	errors := inputs.map(new_char_parser_error(it, .tag))

	for i, input in inputs {
		a_b_satisfy(input) or { assert errors[i] == err }
	}
}
