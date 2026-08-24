import std/[strutils, strformat, sugar, tables]

func addition(a: int, b: int): int =
    return a + b

func subtraction(a: int, b: int): int =
    return b - a

func multiplication(a: int, b: int): int =
    return a * b

func division(a: int, b: int): int =
    return b div a

func modulo(a: int, b: int): int =
    return b mod a

func conjuction(a: int, b: int): int =
    return b and a

func disjunction(a: int, b: int): int =
    return b or a

func equal(a: int, b: int): int =
    if a == b:
        return -1
    return 0

func invert(a: int): int =
    if a == 0:
        return -1
    return 0

var binaryOperations = {
        "+": addition,
        "-": subtraction,
        "*": multiplication,
        "/": division,
        "mod": modulo,
        "and": conjuction,
        "or": disjunction,
        "=": equal,
    }.toTable

var unaryOperations = {
        "invert": invert,
    }.toTable

proc unquote(word: var string) =
    assert word[0] == '['
    assert word[^1] == ']'
    word.removePrefix("[")
    word.removeSuffix("]")

proc eval*(stack: var seq[string], word: string, dictionary: var Table[string, string]) =
    if word in ["+", "-", "*", "/", "mod", "or", "and", "="]:
        let a = stack.pop.parseInt
        let b = stack.pop.parseInt
        proc passAandB(f: (int, int) -> int): int = f(a, b)
        let c = passAandB(binaryOperations[word])
        stack.add($c)
    elif word in ["invert"]:
        let a = stack.pop.parseInt
        proc passA(f: (int) -> int): int = f(a)
        let b = passA(unaryOperations[word])
        stack.add($b)
    elif word == "dup":
        let n = stack.pop
        stack.add(n)
        stack.add(n)
    elif word == "drop":
        discard stack.pop
    elif word == "swap":
        let n2 = stack.pop
        let n1 = stack.pop
        stack.add(n2)
        stack.add(n1)
    elif word == "over":
        let n2 = stack.pop
        let n1 = stack.pop
        stack.add(n1)
        stack.add(n2)
        stack.add(n1)
    elif word == "rot":
        let n3 = stack.pop
        let n2 = stack.pop
        let n1 = stack.pop
        stack.add(n2)
        stack.add(n3)
        stack.add(n1)
    elif word == "apply":
        var program = stack.pop
        program.unquote
        if program[0] == '[' and program[^1] == ']':
            stack.add(program)
        else:
            for p in program.split(" "):
                stack.eval(p, dictionary)
    elif word == "compose":
        var a = stack.pop
        a.unquote
        var b = stack.pop
        b.unquote
        if b == "" and a == "":
            stack.add("[]")
        elif b == "":
            stack.add(fmt"[{a}]")
        elif a == "":
            stack.add(fmt"[{b}]")
        else:
            stack.add(fmt"[{b} {a}]")
    elif word == "unit":
        var a = stack.pop
        stack.add(fmt"[{a}]")
    elif word == "ifte":
        var alternative = stack.pop
        var consequent = stack.pop
        var condition = stack.pop
        condition.unquote
        for cond in condition.split(" "):
            stack.eval(cond, dictionary)
        var res = stack.pop.parseInt
        if res != 0:
            consequent.unquote
            for cons in consequent.split(" "):
                stack.eval(cons, dictionary)
        else:
            alternative.unquote
            for alt in alternative.split(" "):
                stack.eval(alt, dictionary)
    elif word == "loop":
        var program = stack.pop
        var times = stack.pop.parseInt
        program.unquote
        for i in 1..times:
            dictionary["index"] = $i
            for p in program.split(" "):
                stack.eval(p, dictionary)
    elif word == ".":
        echo stack.pop
    elif word == "":
        discard
    else:
        try:
            let definition = dictionary[word]
            for w in definition.split(" "):
                stack.eval(w, dictionary)
        except KeyError:
            stack.add(word)

proc defineWord*(dictionary: var Table[string, string], words: seq[string]) =
    assert words[0] == ":"
    assert words[^1] == ";"
    let word = words[1]
    let definition = words[2..^2].join(" ")
    dictionary[word] = definition

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
