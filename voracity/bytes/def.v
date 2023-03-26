module bytes

pub type BytesParser = fn (string) !(string, string)
