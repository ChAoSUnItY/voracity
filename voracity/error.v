module voracity

// Fulfills IError's implementation
pub struct ParseError {
mut:
	msg string
	code int
}

pub fn (error &ParseError) code() int {
	return error.code
}

pub fn (error &ParseError) msg() string {
	return 'offset: ${error.code}, expected: ${error.msg}'
}

pub fn (error ParseError) err() IError {
	return IError(error)
}
