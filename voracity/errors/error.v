module errors

interface ErrorKind {}

// Fulfills IError's implementation
pub struct ParseError {
mut:
	remaining string
	kind      ErrorKind
}

pub fn new_parse_error(remaining string, kind ErrorKind) IError {
	return IError(ParseError{remaining, kind})
}

pub fn (err &ParseError) msg() string {
	return 'Remaining: ${err.remaining}, kind: ${err.kind}'
}

pub fn (_ &ParseError) code() int {
	return -1
}
