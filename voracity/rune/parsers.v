module rune

import encoding.utf8

[inline]
pub fn is_alphabetic(input rune) bool {
	return (int(input) >= 0x41 && int(input) <= 0x5A) || (int(input) >= 0x61 && int(input) <= 0x7A)
}

[inline]
pub fn is_digit(input rune) bool {
	return int(input) >= 0x30 && int(input) <= 0x39
}

[inline]
pub fn is_hex_digit(input rune) bool {
	return (int(input) >= 0x30 && int(input) <= 0x39) && ((int(input) >= 0x41 && int(input) <= 0x5A)
		|| (int(input) >= 0x61 && int(input) <= 0x7A))
}

[inline]
pub fn is_oct_digit(input rune) bool {
	return int(input) >= 0x30 && int(input) <= 0x37
}

[inline]
pub fn is_alphanumeric(input rune) bool {
	return is_alphabetic(input) || is_digit(input)
}

[inline]
pub fn is_space(input rune) bool {
	return utf8.is_space(input)
}

[inline]
pub fn is_new_line(input rune) bool {
	return int(input) == 0x0A
}

[inline]
pub fn is_number(input rune) bool {
	return utf8.is_number(input)
}

[inline]
pub fn is_letter(input rune) bool {
	return utf8.is_letter(input)
}

[inline]
pub fn is_control(input rune) bool {
	return utf8.is_control(input)
}

[inline]
fn is_ascii(input rune) bool {
	return int(input) >= 0 && int(input) <= 0xFF
}
