module test

import voracity.bytes

fn test_tag() {
	tag := bytes.tag('V')
	inputs := ['VLang', 'V']
	remains := ['Lang', '']

	for i, input in inputs {
		got, remain := tag(input)!

		assert got == 'V'
		assert remain == remains[i]
	}
}

fn test_tag_no_case() {
	tag_no_case := bytes.tag_no_case('v')
	inputs := ['VLang', 'V']
	remains := ['Lang', '']

	for i, input in inputs {
		got, remain := tag_no_case(input)!

		assert got == 'V'
		assert remain == remains[i]
	}
}
