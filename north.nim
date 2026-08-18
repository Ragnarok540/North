var stack = newSeqOfCap[string](5)
echo stack
stack.add("3")
stack.add("2")
stack.add("+")
echo stack
echo stack.pop
echo stack.pop
echo stack.pop

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
