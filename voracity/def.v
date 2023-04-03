module voracity

// complete.bytes

pub type BytesParser = fn (string) !(string, string)

pub type BytesPredicate = fn (byte) bool

// complete.character

pub type CharParser = fn (string) !(u8, string)

[inline]
pub fn (parser CharParser) as_bytes_parser() BytesParser {
	return fn [parser] (input string) !(string, string) {
		return if got, remain := parser(input) {
			got.ascii_str(), remain
		} else {
			err
		}
	}
}

pub type CharPredicate = fn (u8) bool
