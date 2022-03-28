module voracity

import strings

const (
	ws_set = [`\t`, `\r`, `\n`, ` `]	
)

type CombinatorFn = fn (input voidptr, args ...voidptr) Result

struct ParseError {
	Error
	combinator_name string
	input string
	predict string
}

fn (err ParseError) msg() string {
	return "Unable to parse with functor `${err.combinator_name:}`:\nGot:      ${err.input}\nRequires: ${err.predict}"
}

struct Combinator {
	comb_fn CombinatorFn
	args	[]voidptr
}

struct Result {
	ok	  ResultPair
	error &ParseError
}

pub fn (r Result) str() string {
	return if isnil(r.error) {
		r.ok.str()
	} else {
		r.error.msg()
	}
}

pub fn (r Result) str_t<L, R>() string {
	return if isnil(r.error) {
		r.ok.str_t<L, R>()
	} else {
		r.error.msg()
	}
}

struct ResultPair {
	remain voidptr
	result voidptr
}

pub fn (r ResultPair) str_t<L, R>() string {
	return '(${voidptr_to_str<L>(r.remain)}, ${voidptr_to_str<R>(r.result)})'
}

fn voidptr_to_str<T>(vptr voidptr) string {
	return $if T is string {
		unsafe {
			str(vptr)
		}
	} $else {
		vptr
	}
}

pub fn parse_str(input string, combinator Combinator) Result {
	return combinator.comb_fn(ptr(input), combinator.args)
}

pub fn parse(input voidptr, combinator Combinator) Result {
	return combinator.comb_fn(input, combinator.args)
}

// ======================================= //
//				Combinators				   //
// ======================================= //

pub fn tag(tag string) Combinator {
	return Combinator{
		tag_,
		[ptr(tag)]
	}
}

fn tag_(input voidptr, args ...voidptr) Result {
	input_str := str(input)
	tag_str := str(args[0])

	return if input_str.starts_with(tag_str) {
		remain := input_str.replace_once(tag_str, "")
		ok(ptr(remain), args[0])
	} else {
		err(make_error("tag", input_str, tag_str))
	}
}

pub fn multispace0() Combinator {
	return Combinator{
		multispace0_,
		[]
	}
}

fn multispace0_(input voidptr, args ...voidptr) Result {
	input_str := str(input)
	input_runes := input_str.runes()
	result, index := zom(input_runes, fn (r rune) bool { return r in ws_set })

	return ok(ptr(input_runes[index..].string()), ptr(result))
}

// ======================================= //
//				Utilities				   //
// ======================================= //

// Zero or more
fn zom(runes []rune, predicate fn (rune) bool) (string, int) {
	mut last_index := -1
	mut builder := strings.new_builder(16)

	for i in 0..runes.len {
		if predicate(runes[i]) {
			builder.write_rune(runes[i])
			last_index = i
		} else {
			break
		}
	}

	return builder.str(), if last_index == -1 { 0 } else { last_index + 1 }
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

fn ok(remain voidptr, result voidptr) Result {
	return Result{
		ResultPair{
			remain,
			result
		},
		voidptr(0)
	}
}

fn err(err ParseError) Result {
	return Result{
		ResultPair{},
		&err
	}
}

fn make_error(combinator_name string, input string, predict string) &ParseError {
	return &ParseError { 
		combinator_name: combinator_name, 
		input: input,
		predict: predict
	}
}