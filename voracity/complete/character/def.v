module character

import voracity

fn new_char_parser_error(remaining string, kind ErrorKind) IError {
	return voracity.new_parse_error(remaining, voracity.ErrorKind(kind))
}
