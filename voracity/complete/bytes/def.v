module bytes

import voracity

pub type BytesParser = fn (string) !(string, string)
pub type BytesPredicate = fn (byte) bool

fn new_bytes_parser_error(remaining string, kind ErrorKind) IError {
	return voracity.new_parse_error(remaining, voracity.ErrorKind(kind))
}
