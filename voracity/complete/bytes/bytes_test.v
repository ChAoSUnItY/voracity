module bytes

import voracity.character
import voracity.complete.character as complete_character

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

fn test_take() {
	take6 := take(6)
	inputs := ['1234567', 'things']
	gots := ['123456', 'things']
	remains := ['7', '']

	for i, input in inputs {
		got, remain := take6(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_err() {
	take6 := take(6)
	inputs := ['short', '']
	errors := inputs.map(new_bytes_parser_error(it, .take))

	for i, input in inputs {
		take6(input) or { assert errors[i] == err }
	}
}

fn test_take_until() {
	until_eof := take_until('eof')
	inputs := ['hello, worldeof', '1eof2eof']
	gots := ['hello, world', '1']
	remains := ['eof', 'eof2eof']

	for i, input in inputs {
		got, remain := until_eof(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_until_err() {
	until_eof := take_until('eof')
	inputs := ['hello, world', '']
	errors := inputs.map(new_bytes_parser_error(it, .take_until))

	for i, input in inputs {
		until_eof(input) or { assert errors[i] == err }
	}
}

fn test_take_until1() {
	until_eof := take_until1('eof')
	inputs := ['hello, worldeof', '1eof2eof']
	gots := ['hello, world', '1']
	remains := ['eof', 'eof2eof']

	for i, input in inputs {
		got, remain := until_eof(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_take_until1_err() {
	until_eof := take_until('eof')
	inputs := ['hello, world', '', 'eof']
	errors := inputs.map(new_bytes_parser_error(it, .take_until))

	for i, input in inputs {
		until_eof(input) or { assert errors[i] == err }
	}
}

fn test_escaped() {
	esc := escaped(digit1(), '\\'[0], complete_character.one_of('"n\\').as_bytes_parser())
	inputs := ['123;', '12\\"34;']
	gots := ['123', '12\\"34']

	for i, input in inputs {
		got, remain := esc(input)!

		assert got == gots[i]
		assert remain == ';'
	}
}

fn test_escaped_err() {
	esc := escaped(digit1(), '\\'[0], complete_character.one_of('"n\\').as_bytes_parser())
	inputs := ['abcd']
	errors := inputs.map(new_bytes_parser_error(it, .escaped))

	for i, input in inputs {
		esc(input) or { assert errors[i] == err }
	}
}

fn test_crlf() {
	inputs := ['\r\n', '\r\nabc']
	remains := ['', 'abc']

	for i, input in inputs {
		got, remain := crlf()(input)!

		assert got == '\r\n'
		assert remain == remains[i]
	}
}

fn test_crlf_err() {
	inputs := ['abc\r\n', '']
	errors := inputs.map(new_bytes_parser_error(it, .crlf))

	for i, input in inputs {
		crlf()(input) or { assert errors[i] == err }
	}
}

fn test_not_line_ending() {
	inputs := ['ab\r\nc', 'ab\nc', 'abc', '']
	gots := ['ab', 'ab', 'abc', '']
	remains := ['\r\nc', '\nc', '', '']

	for i, input in inputs {
		got, remain := not_line_ending()(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_not_line_ending_err() {
	inputs := ['a\rb\nc', 'a\rbc']
	errors := inputs.map(new_bytes_parser_error(it, .not_line_ending))

	for i, input in inputs {
		not_line_ending()(input) or { assert errors[i] == err }
	}
}

fn test_line_ending() {
	inputs := ['\r\n', '\n', '\r\nabc', '\nabc']
	gots := ['\r\n', '\n', '\r\n', '\n']
	remains := ['', '', 'abc', 'abc']

	for i, input in inputs {
		got, remain := line_ending()(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_line_ending_err() {
	inputs := ['abc\r\n', 'abc\n', 'a\rb\nc', '']
	errors := inputs.map(new_bytes_parser_error(it, .line_ending))

	for i, input in inputs {
		not_line_ending()(input) or { assert errors[i] == err }
	}
}

fn test_alpha0() {
	inputs := ['a', 'a123', 'abc123', '']
	gots := ['a', 'a', 'abc', '']
	remains := ['', '123', '123', '']

	for i, input in inputs {
		got, remain := alpha0()(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_alpha1() {
	inputs := ['a', 'a123', 'abc123']
	gots := ['a', 'a', 'abc']
	remains := ['', '123', '123']

	for i, input in inputs {
		got, remain := alpha1()(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_alpha1_err() {
	inputs := ['1a', '123abc', '']
	errors := inputs.map(new_bytes_parser_error(it, .alpha1))

	for i, input in inputs {
		alpha1()(input) or { assert errors[i] == err }
	}
}

fn test_digit0() {
	inputs := ['1', '1abc', '123abc', '']
	gots := ['1', '1', '123', '']
	remains := ['', 'abc', 'abc', '']

	for i, input in inputs {
		got, remain := digit0()(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_digit1() {
	inputs := ['1', '1abc', '123abc']
	gots := ['1', '1', '123']
	remains := ['', 'abc', 'abc']

	for i, input in inputs {
		got, remain := digit1()(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_digit1_err() {
	inputs := ['a1', 'abc123', '']
	errors := inputs.map(new_bytes_parser_error(it, .digit1))

	for i, input in inputs {
		digit1()(input) or { assert errors[i] == err }
	}
}
