module voracity

// complete.bytes

pub type BytesParser = fn (string) !(string, string)

pub type BytesPredicate = fn (byte) bool

// complete.character

pub type CharParser = fn (string) !(u8, string)

pub type CharPredicate = fn (u8) bool
