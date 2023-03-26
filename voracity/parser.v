module voracity

pub type Parser[I, O, R] = fn (I) !(O, R)
