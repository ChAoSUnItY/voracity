module branch

import voracity { Parser }

pub fn alt[I, O, R](parsers ...Parser[I, O, R]) Parser[I, O, R] {
	return fn [I, O, R] [parsers] (input I) !(O, R) {
		return parsers[0](input)
	}
}
