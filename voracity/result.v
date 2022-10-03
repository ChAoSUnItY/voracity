module voracity

pub interface AsString {
	str() string
}

struct Result {
pub:
	token    string
	children []Result
	result   AsString
}

pub fn (r &Result) str() string {
	if !isnil(r.result) {
		return r.result.str()
	}

	if r.children.len > 0 {
		mut sb := []string{}

		for child in r.children {
			sb << child.str()
		}

		return '[${sb.join(', ')}]'
	}

	return r.token
}
