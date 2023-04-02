module bytes

import voracity

fn new_bytes_parser_error(remaining string, kind ErrorKind) IError {
	return voracity.new_parse_error(remaining, voracity.ErrorKind(kind))
}
