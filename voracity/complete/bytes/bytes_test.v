module bytes

fn test_tag() {
	hello_word_tag := tag('Hello')
	inputs := ['Hello World']
	gots := ['Hello']
	remains := [' World']

	for i, input in inputs {
		got, remain := hello_word_tag(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_tag_err() {
	hello_tag := tag('Hello')
	inputs := ['Something', '']
	errors := inputs.map(new_bytes_parser_error(it, .tag))

	for i, input in inputs {
		hello_tag(input) or { assert errors[i] == err }
	}
}

fn test_tag_no_case() {
	hello_tag_no_case := tag_no_case('hello')
	inputs := ['Hello, World!', 'hello, World!', 'HeLlO, World!']
	gots := ['Hello', 'hello', 'HeLlO']
	remains := [', World!', ', World!', ', World!']

	for i, input in inputs {
		got, remain := hello_tag_no_case(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_tag_no_case_err() {
	hello_tag_no_case := tag_no_case('hello')
	inputs := ['Something', '']
	errors := inputs.map(new_bytes_parser_error(it, .tag_no_case))

	for i, input in inputs {
		hello_tag_no_case(input) or { assert errors[i] == err }
	}
}

fn test_is_not() {
	not_space := is_not(' \t\r\n')
	inputs := ['Hello, World!', 'Sometimes\t', 'Nospace']
	gots := ['Hello,', 'Sometimes', '']
	remains := [' World!', '\t', 'Nospace']

	for i, input in inputs {
		got, remain := not_space(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_is_not_err() {
	not_space := is_not(' \t\r\n')
	inputs := ['']
	errors := inputs.map(new_bytes_parser_error(it, .is_not))

	for i, input in inputs {
		not_space(input) or { assert errors[i] == err }
	}
}

fn test_is_a() {
	hex := is_a('1234567890ABCDEF')
	inputs := ['123 and voila', 'DEADBEEF and others', 'BADBABEsomething', 'D15EA5E']
	gots := ['123', 'DEADBEEF', 'BADBABE', 'D15EA5E']
	remains := [' and voila', ' and others', 'something', '']

	for i, input in inputs {
		got, remain := hex(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_is_a_err() {
	hex := is_a('1234567890ABCDEF')
	inputs := ['']
	errors := inputs.map(new_bytes_parser_error(it, .is_a))

	for i, input in inputs {
		hex(input) or { assert errors[i] == err }
	}
}
