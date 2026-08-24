import std/[strutils, tables]
import north

var dictionary = {
    "add1": "1 +",
    "square": "dup *",
}.toTable

proc test_addition() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 +"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["5"]
    echo "test_addition good!"

proc test_subtraction() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 -"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["-1"]
    echo "test_subtraction good!"

proc test_multiplication() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["6"]
    echo "test_multiplication good!"

proc test_division() =
    var
        stack = newSeqOfCap[string](4)
        line = "4 2 /"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["2"]
    echo "test_division good!"

proc test_rpn() =
    var
        stack = newSeqOfCap[string](8)
        line = "5 2 + 10 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["70"]
    echo "test_rpn good!"

proc test_define() =
    var
        stack = newSeqOfCap[string](2)
        line = ": foo 100 + ;"
        words = line.split(" ")
    dictionary.defineWord(words)
    line = "1 foo"
    words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["101"]
    echo "test_define good!"

proc test_dup() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 dup"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "3", "3"]
    echo "test_dup good!"

proc test_drop() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 drop"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2"]
    echo "test_drop good!"

proc test_swap() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 4 swap"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "4", "3"]
    echo "test_swap good!"

proc test_over() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 over"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "3", "2"]
    echo "test_over good!"

proc test_rot() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 rot"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["2", "3", "1"]
    echo "test_rot good!"

proc test_apply() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [add1] apply"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "4"]
    echo "test_apply good!"

proc test_compose() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [add1] [square] compose"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "3", "[add1 square]"]
    echo "test_compose good!"

proc test_ifte_1() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [condition] [consequent] [alternative] ifte"
        words = line.split(" ")
    dictionary.defineWord(": condition 3 = ;".split(" "))
    dictionary.defineWord(": consequent 123 ;".split(" "))
    dictionary.defineWord(": alternative 456 ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "123"]
    echo "test_ifte_1 good!"

proc test_ifte_2() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [condition] [consequent] [alternative] ifte"
        words = line.split(" ")
    dictionary.defineWord(": condition 2 = ;".split(" "))
    dictionary.defineWord(": consequent 123 ;".split(" "))
    dictionary.defineWord(": alternative 456 ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "456"]
    echo "test_ifte_2 good!"

proc test_ifte_3() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [condition] [consequent] [alternative] ifte"
        words = line.split(" ")
    dictionary.defineWord(": condition 2 = dup ;".split(" "))
    dictionary.defineWord(": consequent 123 ;".split(" "))
    dictionary.defineWord(": alternative 456 ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "0", "456"]
    echo "test_ifte_3 good!"

proc test_loop() =
    var
        stack = newSeqOfCap[string](8)
        line = "10 [print-index] loop"
        words = line.split(" ")
    dictionary.defineWord(": print-index index . ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @[]
    echo "test_loop good!"

proc test_dot() =
    var
        stack = newSeqOfCap[string](2)
        line = "1 ."
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @[]
    echo "test_dot good!"

test_addition()
test_subtraction()
test_multiplication()
test_division()
test_rpn()
test_define()
test_dup()
test_drop()
test_swap()
test_over()
test_rot()
test_apply()
test_compose()
test_ifte_1()
test_ifte_2()
test_ifte_3()
test_loop()
test_dot()

# mkdir -p bin
# nim c -o:bin/test test.nim 
# ./bin/test
