module voracity

import encoding.utf8 { raw_index, is_space }

pub struct State {
	input string
mut:
	pos int
	cut int
	error Error
	wd VoidParser
}
