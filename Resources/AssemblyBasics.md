# ASSEMBLY BASICS for NASM Compiler
```
label:
  ........
  ........
  ..CODE..
  ........
  ........
```

## Directives:
```
equ -> makes a constant
byte -> 
word -> word
dword -> double word
```
## Interrupts: [UNAVAIABLE in PROTECTED MODE]
`INT 0xXX` -> Assembly Syntax for calling Interrupts


`int 0x10` -> [Video Services](https://en.wikipedia.org/wiki/INT_10H)


`int 0x13` -> [Sector-Based Disk Access](https://en.wikipedia.org/wiki/INT_13H)
```
Function 0x42 (42h) uses Little Endian
```
## Resources
[Doeppner-Brown University](https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf)


[??-Stanford University](https://web.stanford.edu/class/cs107/resources/x86-64-reference.pdf)


[Assembly Instructions](https://en.wikipedia.org/wiki/X86_instruction_listings) `Unused`


### Extras
> It's Easy to Get Money. Hardest Part is to keep it Rollin' MF - Andrew Huang
