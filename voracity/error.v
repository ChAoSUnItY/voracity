module voracity

// Fulfills IError's implementation
pub struct ParseError {
mut:
	msg  string
	code int
}

pub fn (error &ParseError) code() int {
	return error.code
}

pub fn (error &ParseError) msg() string {
	return 'offset: $error.code, expected: $error.msg'
}

pub fn (error ParseError) err() IError {
	return IError(error)
}

// Fulfills IError's implementation
[noinit]
pub struct UnparsedError {
mut:
	msg  string
	code int
}

pub fn unparsed_error(unparsed string, location int) UnparsedError {
	return UnparsedError{unparsed, location}
}

pub fn (error &UnparsedError) code() int {
	return error.code
}

pub fn (error &UnparsedError) msg() string {
	return 'left unparsed: $error.msg'
}

pub fn (error UnparsedError) err() IError {
	return IError(error)
}
