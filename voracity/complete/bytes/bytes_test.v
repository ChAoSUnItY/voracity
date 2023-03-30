module bytes

import voracity.character

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

		println(got)
		println(remain)

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

fn test_take_while() {
	is_alpha := take_while(character.is_alphabetic)
	inputs := ['latin123', '12345', 'latin', '']
	gots := ['latin', '', 'latin', '']
	remains := ['123', '12345', '', '']

	for i, input in inputs {
		got, remain := is_alpha(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_while1() {
	is_alpha := take_while1(character.is_alphabetic)
	inputs := ['latin123', 'latin']
	gots := ['latin', 'latin']
	remains := ['123', '']

	for i, input in inputs {
		got, remain := is_alpha(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_while1_err() {
	is_alpha := take_while1(character.is_alphabetic)
	inputs := ['12345', '']
	errors := inputs.map(new_bytes_parser_error(it, .take_while1))

	for i, input in inputs {
		is_alpha(input) or { assert errors[i] == err }
	}
}

fn test_take_while_m_n() {
	is_alpha := take_while_m_n(character.is_alphabetic, 3, 6)
	inputs := ['latin123', 'lengthy', 'latin']
	gots := ['latin', 'length', 'latin']
	remains := ['123', 'y', '']

	for i, input in inputs {
		got, remain := is_alpha(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_while_m_n_err() {
	is_alpha := take_while_m_n(character.is_alphabetic, 3, 6)
	inputs := ['ed', '12345']
	errors := inputs.map(new_bytes_parser_error(it, .take_while_m_n))

	for i, input in inputs {
		is_alpha(input) or { assert errors[i] == err }
	}
}

fn test_take_till() {
	is_colon := take_till(fn (b byte) bool {
		return b == ':'[0]
	})
	inputs := ['latin:123', ':empty matched', '12345', '']
	gots := ['latin', '', '12345', '']
	remains := [':123', ':empty matched', '', '']

	for i, input in inputs {
		got, remain := is_colon(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_till1() {
	is_colon := take_till1(fn (b byte) bool {
		return b == ':'[0]
	})
	inputs := ['latin:123', '12345']
	gots := ['latin', '12345']
	remains := [':123', '']

	for i, input in inputs {
		got, remain := is_colon(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_till1_err() {
	is_colon := take_till1(fn (b byte) bool {
		return b == ':'[0]
	})
	inputs := [':empty matched', '']
	errors := inputs.map(new_bytes_parser_error(it, .take_till1))

	for i, input in inputs {
		is_colon(input) or { assert errors[i] == err }
	}
}
