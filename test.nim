import std/[strutils, tables]
import north

var dictionary = {
    "add1": "1 +"
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

proc test_dot() =
    var
        stack = newSeqOfCap[string](2)
        line = "1 ."
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @[]
    echo "test_dot good!"

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

test_addition()
test_subtraction()
test_multiplication()
test_division()
test_rpn()
test_dot()
test_define()
test_dup()
test_drop()
test_swap()
test_over()
test_rot()

# mkdir -p bin
# nim c -o:bin/test test.nim 
# ./bin/test
