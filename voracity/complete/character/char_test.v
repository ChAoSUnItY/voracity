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
