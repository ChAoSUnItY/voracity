module branch

import voracity { Parser }

pub enum ErrorKind {
	alt
}

pub fn alt[I, O, R](parsers ...Parser[I, O, R]) Parser[I, O, R] {
	return fn [parsers] [I, O, R](input I) !(O, R) {
		mut last_err := new_branch_parser_error(input, .alt)

		for parser in parsers {
			if got, remain := parser(input) {
				return got, remain
			} else {
				last_err = err
			}
		}

		return last_err
	}
}
