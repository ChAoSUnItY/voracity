module character

fn test_char() {
	a_char := char('a'[0])
	inputs := ['a', 'abc']
	remains := ['', 'bc']

	for i, input in inputs {
		got, remain := a_char(input)!

		assert got == 'a'[0]
		assert remain == remains[i]
	}
}
