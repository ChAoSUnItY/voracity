module character

import voracity

pub type CharParser = fn (string) !(byte, string)
pub type CharParserOpt = fn (string) ?(byte, string)

pub type CharPredicate = fn (byte) bool

fn new_char_parser_error(remaining string, kind ErrorKind) IError {
	return voracity.new_parse_error(remaining, voracity.ErrorKind(kind))
}
