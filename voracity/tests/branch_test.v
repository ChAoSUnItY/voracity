module tests

import voracity.branch
import voracity.combinator
import voracity.complete.bytes

fn test_alt() {
	esc_char_replace := branch.alt[string, string, string](combinator.value[string, string, string]('"',
		bytes.tag('\\"')), combinator.value[string, string, string]('\\', bytes.tag('\\\\')),
		combinator.value[string, string, string]('\n', bytes.tag('\\n')))
	inputs := ['\\"', '\\\\', '\\n', '\\"\\\\', '\\\\\\n', '\\n\\\\']
	gots := ['"', '\\', '\n', '"', '\\', '\n']
	remains := ['', '', '', '\\\\', '\\n', '\\\\']

	for i, input in inputs {
		got, remain := esc_char_replace(input)!

		assert got == gots[i]
		assert remain == remains[i]
	}
}

fn test_alt_err() {
	esc_char_replace := branch.alt[string, string, string](combinator.value[string, string, string]('"',
		bytes.tag('\\"')), combinator.value[string, string, string]('\\', bytes.tag('\\\\')),
		combinator.value[string, string, string]('\n', bytes.tag('\\n')))
	inputs := ['']
	errors := inputs.map(bytes.new_bytes_parser_error(it, .tag))

	for i, input in inputs {
		esc_char_replace(input) or { assert err == errors[i] }
	}
}

fn test_alt_empty_err() {
	empty_alt := branch.alt[string, string, string]()
	inputs := ['']

	errors := inputs.map(branch.new_branch_parser_error(it, .alt))

	for i, input in inputs {
		empty_alt(input) or { assert err == errors[i] }
	}
}
