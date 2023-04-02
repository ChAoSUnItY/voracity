# DESIGN NOTES

## Upper parser combinator type casting
### Issued in Vlang 0.3

Currently V's type system is still not smart enough to conclude and 
infer generic type parameters and inject into aliased function type,
therefore, we introduce a simple **upper parser combinator type casting**
system to resolve this issue:

`Graph I: CharParser-ByteParser upper type casting`

```
BytesParser (fn (string) !(string, string))
                           ▲
                           │ u8.ascii_str()
                           │
CharParser  (fn (string) !(u8    , string))
```
