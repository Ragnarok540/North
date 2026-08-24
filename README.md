# North
Like Forth, but in Nim

```Factor
: div-3 3 mod 0 = dup ;
: print-fizz Fizz . ;
: fizz? [div-3] [print-fizz] [] ifte ;

: div-5 5 mod 0 = dup ;
: print-buzz Buzz . ;
: buzz? [div-5] [print-buzz] [] ifte ;

: fizz-buzz? index dup fizz? swap buzz? or invert ;

: print-index index . ;
: print-fb [fizz-buzz?] [print-index] [] ifte ;
: do-fizz-buzz 25 [print-fb] loop ;

do-fizz-buzz
```

- https://skilldrick.github.io/easyforth/
- https://wiki.c2.com/?ForthLanguage
