module character

import voracity

pub type CharParser = fn (string) !(u8, string)

pub type CharPredicate = fn (u8) bool

fn new_char_parser_error(remaining string, kind ErrorKind) IError {
	return voracity.new_parse_error(remaining, voracity.ErrorKind(kind))
}
