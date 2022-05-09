default:
	clear
	jflex ToY.l
	bison -t ToY.y -L java
	javac *.java

test: 
		java ToY < $(filename)

clean:
	rm ToY.java *.class Yylex.java Yylex.java\~

