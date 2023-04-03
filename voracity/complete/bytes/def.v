module bytes

import voracity.errors

pub fn new_bytes_parser_error(remaining string, kind ErrorKind) IError {
	return errors.new_parse_error(remaining, errors.ErrorKind(kind))
}
