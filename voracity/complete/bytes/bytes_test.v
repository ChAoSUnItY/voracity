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
	errors := [new_bytes_parser_error('Something', .tag), new_bytes_parser_error('', .tag)]

	for i, input in inputs {
		hello_tag(input) or {
			assert errors[i] == err
		}
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
	errors := [new_bytes_parser_error('', .is_not)]

	for i, input in inputs {
		not_space(input) or {
			assert errors[i] == err
		}
	}
}
