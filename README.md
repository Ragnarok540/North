# North
Like Forth, but in Nim

```Factor
: div-3 3 mod 0 = dup ;
: print-fizz Fizz . ;
: fizz? [div-3] [print-fizz] [] if ;

: div-5 5 mod 0 = dup ;
: print-buzz Buzz . ;
: buzz? [div-5] [print-buzz] [] if ;

: fizz-buzz? i dup fizz? swap buzz? or invert ;

: print-index i . ;
: print-fb [fizz-buzz?] [print-index] [] if ;
: do-fizz-buzz 25 [i] [print-fb] loop ;

do-fizz-buzz
```

- https://skilldrick.github.io/easyforth/
- https://wiki.c2.com/?ForthLanguage
