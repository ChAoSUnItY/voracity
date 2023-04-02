module voracity

interface Any {}

pub type IBytesParser = fn (string) !(Any, string)
