import std/[strutils, tables]
import north

var dictionary = {
    "add1": "1 +",
    "square": "dup *",
}.toTable

proc testAddition() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 +"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["5"]
    echo "testAddition good!"

proc testSubtraction() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 -"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["-1"]
    echo "testSubtraction good!"

proc testMultiplication() =
    var
        stack = newSeqOfCap[string](4)
        line = "2 3 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["6"]
    echo "testMultiplication good!"

proc testDivision() =
    var
        stack = newSeqOfCap[string](4)
        line = "4 2 /"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["2"]
    echo "testDivision good!"

proc testRpn() =
    var
        stack = newSeqOfCap[string](8)
        line = "5 2 + 10 *"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["70"]
    echo "testRpn good!"

proc testModulo() =
    var
        stack = newSeqOfCap[string](4)
        line = "3 2 mod"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1"]
    echo "testModulo good!"

proc testConjuction() =
    var
        stack = newSeqOfCap[string](4)
        line = "0 0 and"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["0"]
    echo "testConjuction good!"

proc testDisjunction() =
    var
        stack = newSeqOfCap[string](4)
        line = "0 -1 or"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["-1"]
    echo "testDisjunction good!"

proc testEqual() =
    var
        stack = newSeqOfCap[string](4)
        line = "1 1 ="
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["-1"]
    echo "testEqual good!"

proc testInvert() =
    var
        stack = newSeqOfCap[string](4)
        line = "0 invert"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["-1"]
    echo "testInvert good!"

proc testDefine() =
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
    echo "testDefine good!"

proc testDup() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 dup"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "3", "3"]
    echo "testDup good!"

proc testDrop() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 drop"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2"]
    echo "testDrop good!"

proc testSwap() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 4 swap"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "4", "3"]
    echo "testSwap good!"

proc testOver() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 over"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "3", "2"]
    echo "testOver good!"

proc testRot() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 rot"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["2", "3", "1"]
    echo "testRot good!"

proc testApply() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [add1] apply"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "4"]
    echo "testApply good!"

proc testCompose() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [add1] [square] compose"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "3", "[add1 square]"]
    echo "testCompose good!"

proc testUnit() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 unit"
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "[3]"]
    echo "testUnit good!"

proc testIfte1() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [condition] [consequent] [alternative] if"
        words = line.split(" ")
    dictionary.defineWord(": condition 3 = ;".split(" "))
    dictionary.defineWord(": consequent 123 ;".split(" "))
    dictionary.defineWord(": alternative 456 ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "123"]
    echo "testIfte1 good!"

proc testIfte2() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [condition] [consequent] [alternative] if"
        words = line.split(" ")
    dictionary.defineWord(": condition 2 = ;".split(" "))
    dictionary.defineWord(": consequent 123 ;".split(" "))
    dictionary.defineWord(": alternative 456 ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "456"]
    echo "testIfte2 good!"

proc testIfte3() =
    var
        stack = newSeqOfCap[string](8)
        line = "1 2 3 [condition] [consequent] [alternative] if"
        words = line.split(" ")
    dictionary.defineWord(": condition 2 = dup ;".split(" "))
    dictionary.defineWord(": consequent 123 ;".split(" "))
    dictionary.defineWord(": alternative 456 ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @["1", "2", "0", "456"]
    echo "testIfte3 good!"

proc testLoop() =
    var
        stack = newSeqOfCap[string](8)
        line = "10 [i] [print-index] loop"
        words = line.split(" ")
    dictionary.defineWord(": print-index i . ;".split(" "))
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @[]
    echo "testLoop good!"

proc testDot() =
    var
        stack = newSeqOfCap[string](2)
        line = "1 ."
        words = line.split(" ")
    for word in words:
        stack.eval(word, dictionary)
    assert stack == @[]
    echo "testDot good!"

testAddition()
testSubtraction()
testMultiplication()
testDivision()
testRpn()
testModulo()
testConjuction()
testDisjunction()
testEqual()
testInvert()
testDefine()
testDup()
testDrop()
testSwap()
testOver()
testRot()
testApply()
testCompose()
testUnit()
testIfte1()
testIfte2()
testIfte3()
testLoop()
testDot()

# mkdir -p bin
# nim c -o:bin/test test.nim 
# ./bin/test
