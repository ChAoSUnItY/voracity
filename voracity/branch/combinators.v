module branch

import voracity { Parser }

pub enum ErrorKind {
	alt
	permutation
}

[inline]
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

[inline]
pub fn permutation[I, O, R](parsers ...Parser[I, O, R]) Parser[I, []O, R] {
	return fn [parsers] [I, O, R](input I) !([]O, R) {
		mut current_remain := input
		mut last_err := new_branch_parser_error(input, .alt)
		mut results := []?O{len: parsers.len, init: none}

		permutation_loop: for {
			for i, result in results {
				if _ := result {
				} else {
					if got, remain := parsers[i](current_remain) {
						current_remain = remain
						results[i] = got
						continue permutation_loop
					} else {
						last_err = last_err
					}
				}
			}
		}

		mut mapped_results := []O{cap: parsers.len}
		for result in results {
			if exist := result {
				mapped_results << exist
			} else {
				break
			}
		}

		return if mapped_results.len == parsers.len {
			mapped_results, current_remain
		} else {
			last_err
		}
	}
}
