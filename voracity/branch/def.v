module branch

import voracity.errors

pub fn new_branch_parser_error[I](remaining I, kind ErrorKind) IError {
	return errors.new_parse_error(remaining.str(), errors.ErrorKind(kind))
}
