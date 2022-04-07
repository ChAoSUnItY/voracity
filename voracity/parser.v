module voracity

import strings

const (
	ws_set = [`\t`, `\r`, `\n`, ` `]
)

type CombinatorFn<K, V> = fn (input K, args ...voidptr) ?(K, V)
type CombinatorStrFn = fn (input string, args ...voidptr) ?(string, string)

struct ParseError {
	Error
	combinator_name string
	input           string
	predict         string
}

fn (err ParseError) msg() string {
	return 'Unable to parse with functor `$err.combinator_name`:\nGot:      `$err.input`\nRequires: `$err.predict`'
}

fn voidptr_to_str<T>(vptr voidptr) string {
	return $if T is string { unsafe {
			str(vptr)
		} } $else { vptr }
}

pub fn parse<K, V>(input K, combinator (CombinatorFn<K, V>, []voidptr)) ?(K, V) {
	func, args := combinator
	return func(input, args)
}

// ======================================= //
//				Combinators				   //
// ======================================= //

pub fn byte(b byte) (CombinatorStrFn, []voidptr) {
	ascii_str := b.ascii_str()
	return tag_, [ptr(ascii_str)]
}

pub fn bytes(b []byte) (CombinatorStrFn, []voidptr){
	str := b.bytestr()
	return tag_, [ptr(str)]
}

pub fn rune(r rune) (CombinatorStrFn, []voidptr) {
	str := r.str()
	return tag_, [ptr(str)]
}

pub fn runes(r []rune) (CombinatorStrFn, []voidptr) {
	str := r.string()
	return tag_, [ptr(str)]
}

pub fn tag(tag string) (CombinatorStrFn, []voidptr) {
	return tag_, [ptr(tag)]
}

fn tag_(input string, args ...voidptr) ?(string, string) {
	input_str := input
	tag_str := str(args[0])

	return if input_str.starts_with(tag_str) {
		remain := input_str.replace_once(tag_str, '')
		remain, tag_str
	} else {
		make_error('tag', input_str, tag_str)
	}
}

pub fn multispace0() (CombinatorStrFn, []voidptr) {
	return multispace0_, []voidptr{}
}

pub fn multispace1() (CombinatorStrFn, []voidptr) {
	return multispace1_, []voidptr{}
}

fn multispace0_(input string, args ...voidptr) ?(string, string) {
	runes := input.runes()
	result, index := zom(runes, fn (r rune) bool {
		return r in voracity.ws_set
	})

	return runes[index..].string(), result
}

fn multispace1_(input string, args ...voidptr) ?(string, string) {
	runes := input.runes()
	result, index := zom(runes, fn (r rune) bool {
		return r in voracity.ws_set
	})

	return if index == 0 {
		// No match
		IError(make_error('multispace1', input, '`(`\\t` | `\\r` | `\\n` | ` `)`'))
	} else {
		runes[index..].string(), result
	}
}

pub fn alpha0() (CombinatorStrFn, []voidptr) {
	return alpha0_, []voidptr{}
}

pub fn alpha1() (CombinatorStrFn, []voidptr) {
	return alpha1_, []voidptr{}
}

fn alpha0_(input string, args ...voidptr) ?(string, string) {
	runes := input.runes()
	result, index := zom(runes, fn (r rune) bool {
		return match r {
			`A`...`Z` { true }
			`a`...`z` { true }
			else { false }
		}
	})

	return runes[index..].string(), result
}

fn alpha1_(input string, args ...voidptr) ?(string, string) {
	runes := input.runes()
	result, index := zom(runes, fn (r rune) bool {
		return match r {
			`A`...`Z` { true }
			`a`...`z` { true }
			else { false }
		}
	})

	return if index == 0 {
		// No match
		make_error('alpha0', input, '`A`...`Z` | `a`...`z`')
	} else {
		runes[index..].string(), result
	}
}

// ======================================= //
//				Utilities				   //
// ======================================= //

// Zero or more
fn zom(runes []rune, predicate fn (rune) bool) (string, int) {
	mut last_index := -1
	mut builder := strings.new_builder(16)

	for i in 0 .. runes.len {
		if predicate(runes[i]) {
			builder.write_rune(runes[i])
			last_index = i
		} else {
			break
		}
	}

	return builder.str(), if last_index == -1 {
		0
	} else {
		last_index + 1
	}
}

fn str(vptr voidptr) string {
	return unsafe {
		cstring_to_vstring(vptr)
	}
}

fn ptr<T>(val T) voidptr {
	$if T is string {
		return voidptr(val.str)
	} $else {
		return voidptr(val)
	}
}

fn make_error(combinator_name string, input string, predict string) IError {
	return IError(ParseError{
		combinator_name: combinator_name
		input: input
		predict: predict
	})
}
