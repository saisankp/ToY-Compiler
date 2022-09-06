# Compiler Design
This repository contains my code for the ToY Compiler Project assignment for CSU33071 (Compiler Design I) at Trinity College Dublin. I have made a parser and type-checker for the language ToY. The implementation is made in Java using the tools JFlex and Bison. The language ToY is a simple imperative language with procedures and has many similarities with many similarities with C. You can learn more about ToY [here][here].

# How the project works
Input is tokenized by the lexer during the lexical analysis stage. This is done by the `ToY.l` file. These tokens are passed to the bison parser during the parsing stage. This is done by the `ToY.y` file. There is an abstract syntax tree made out of the tokens. This will reinforce the particular layout of a ToY program. If a token is encountered, we use a symbol table to keep track of variables/dealing with redeclaration/variable types. This is done by the `SymbolTable.java` file. For structs, it can be a bit more tricky, as they can link to other structs. Hence, we make Struct objects for the symbol table whenever we encounter a struct. This is done with the help of the `Struct.java` file.

<div align="center">
<img width="570" alt="Screenshot 2022-05-09 at 09 03 18" src="https://user-images.githubusercontent.com/34750736/167367958-a0db0a08-ec31-46a6-aa43-adf724cf9c2f.png">
</div>

# How to compile the project
Compiling the code is easy with the Makefile. Just do:

```
make
```

# How to run the project with an input text file
Testing the code with a test file is easy using the Makefile. Just do:

```
make test filename="filenamePath.txt"
```

# How to access the test suite
I have made pre-made test files in our testing suite. These can be found in the `/testsuite` directory. Inside this directory, there are two more directories called `/ERROR` and `/VALID`. The `/ERROR` directory contains tests which **should fail**. The `/VALID` directory contains tests which **should not fail**. These tests are rigourous and ensure that our parser/type-checker is as correct as we can make it. To run one of our test files, you could do:

```
make test filename="testsuite/VALID/complexStructUsageLinkingWithOtherStructs.txt"
```

# How to clean all the classes after compiling the code
After you run `make`, a lot of classes will be made in the directory. You can simply remove these when you are finished by doing:
```
make clean
```

[saisankp]: https://github.com/saisankp
[submission]: https://github.com/TomaszBogunTCD/CompilerDesignProject
[here]: https://drive.google.com/file/d/1gxw2-ndTEmnGEYORdqqEHanklyHysYYR/view?usp=sharing
