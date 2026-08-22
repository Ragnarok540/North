import std/[strutils, tables]
import north

proc test_addition() =
    var
        stack = newSeqOfCap[string](4)
        dictionary = {"add1": "1 +"}.toTable
        line = "2 3 +"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["5"]
    echo "test_addition good!"

proc test_subtraction() =
    var
        stack = newSeqOfCap[string](4)
        dictionary = {"add1": "1 +"}.toTable
        line = "2 3 -"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["-1"]
    echo "test_subtraction good!"

proc test_multiplication() =
    var
        stack = newSeqOfCap[string](4)
        dictionary = {"add1": "1 +"}.toTable
        line = "2 3 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["6"]
    echo "test_multiplication good!"

proc test_division() =
    var
        stack = newSeqOfCap[string](4)
        dictionary = {"add1": "1 +"}.toTable
        line = "4 2 /"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["2"]
    echo "test_division good!"

proc test_rpn() =
    var
        stack = newSeqOfCap[string](8)
        dictionary = {"add1": "1 +"}.toTable
        line = "5 2 + 10 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["70"]
    echo "test_rpn good!"

proc test_dot() =
    var
        stack = newSeqOfCap[string](2)
        dictionary = {"add1": "1 +"}.toTable
        line = "1 ."
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @[]
    echo "test_dot good!"

proc test_define() =
    var
        stack = newSeqOfCap[string](2)
        dictionary = {"add1": "1 +"}.toTable
        line = ": foo 100 + ;"
        words = line.split(" ")
    dictionary.defineWord(words)
    line = "1 foo"
    words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["101"]
    echo "test_define good!"

test_addition()
test_subtraction()
test_multiplication()
test_division()
test_rpn()
test_dot()
test_define()

# mkdir -p bin
# nim c -o:bin/test test.nim 
# ./bin/test
