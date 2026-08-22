import std/strutils
import north

proc test_addition() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 +"
        words = line.split(" ")
    for word in words:
        stack.eval(word)
    assert stack == @["5"]
    echo "test_addition good!"

proc test_subtraction() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 -"
        words = line.split(" ")
    for word in words:
        stack.eval(word)
    assert stack == @["-1"]
    echo "test_subtraction good!"

proc test_multiplication() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word)
    assert stack == @["6"]
    echo "test_multiplication good!"

proc test_division() =
    var
        stack = newSeqOfCap[string](4)
        line = "4 2 /"
        words = line.split(" ")
    for word in words:
        stack.eval(word)
    assert stack == @["2"]
    echo "test_division good!"

proc test_rpn() =
    var
        stack = newSeqOfCap[string](8)
        line = "5 2 + 10 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word)
    assert stack == @["70"]
    echo "test_rpn good!"

proc test_dot() =
    var
        stack = newSeqOfCap[string](2)
        line = "1 ."
        words = line.split(" ")
    for word in words:
        stack.eval(word)
    assert stack == @[]
    echo "test_dot good!"

test_addition()
test_subtraction()
test_multiplication()
test_division()
test_rpn()
test_dot()

# mkdir -p bin
# nim c -o:bin/test test.nim 
# ./bin/test
