module combinator

import voracity { Parser }

pub fn value[I, O, R](val O, parser Parser[I, O, R]) Parser[I, O, R] {
	return fn [val, parser] [I, O, R](input I) !(O, R) {
		return if _, remain := parser(input) {
			val, remain
		} else {
			err
		}
	}
}
