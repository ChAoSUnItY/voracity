module character

[inline]
pub fn is_alphabetic(input byte) bool {
	return (input >= 0x41 && input <= 0x5A) || (input >= 0x61 && input <= 0x7A)
}

[inline]
pub fn is_digit(input byte) bool {
	return input >= 0x30 && input <= 0x39
}

[inline]
pub fn is_hex_digit(input byte) bool {
	return (input >= 0x30 && input <= 0x39) || (input >= 0x41 && input <= 0x5A)
		|| (input >= 0x61 && input <= 0x7A)
}

[inline]
pub fn is_oct_digit(input byte) bool {
	return input >= 0x30 && input <= 0x37
}

[inline]
pub fn is_alphanumeric(input byte) bool {
	return is_alphabetic(input) || is_digit(input)
}

[inline]
pub fn is_space(input byte) bool {
	return match input {
		`\t`, `\n`, `\v`, `\f`, `\r`, ` `, 0x85, 0xA0 {
			true
		}
		else {
			false
		}
	}
}

[inline]
pub fn is_new_line(input byte) bool {
	return input == 0x0A
}
