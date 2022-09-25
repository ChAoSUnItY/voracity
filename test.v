type CombinatorFn<I, R> = fn (I, ...voidptr) ?(I, R)

pub fn prefix() CombinatorFn<string, string> {
	return CombinatorFn<string, string>(tag)
}

fn tag(s string, args ...voidptr) ?(string, string) {
	return s[1..], s[0].str()
}

fn main() {
	func := prefix()
}
