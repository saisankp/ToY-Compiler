/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Names we will use://////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
RESERVED_BOOL               bool
RESERVED_INT                int
RESERVED_TRUE               true
RESERVED_FALSE              false
RESERVED_VOID               void
RESERVED_PRINTF             printf
RESERVED_STRING             string
RESERVED_STRUCT             struct
RESERVED_IF                 if
RESERVED_THEN               then
RESERVED_ELSE               else
RESERVED_FOR                for
RESERVED_RETURN             return
RESERVED_NOT                not
RESERVED_MOD                mod
RESERVED_OR                 or
RESERVED_AND                and

IDENTIFIER                  id (variable name)
INTEGER                     for integers in the range -2147483648 to 2147483647 (INTEGER.MIN_VALUE & INTEGER.MAX_VALUE in Java)
STRINGLITERAL               for strings (anything inside 2 quotation marks)
COMMENT                     for comments (anything between ("##" or "//") and "\n")
WHITESPACE                  for spaces, tabs, newlines
INVALIDINT                  for input like 1wd7 (having this works out perfect for the logical of program)
STRINGWITHESCAPEDCHARACTERS for input like "Hello \”world\”!" (having this works out perfect for the logical of program)
NEWLINE                     for a new line with \n. We ignore these.
COMMA                       comma for separating struct declarations for example.

SYMBOL_CURLYBRACKET_START   {
SYMBOL_CURLYBRACKET_END     }
SYMBOL_BRACKET_START        (
SYMBOL_BRACKET_END          )
SYMBOL_PLUS                 +
SYMBOL_MINUS                -
SYMBOL_EQ                   =
SYMBOL_DOUBLEEQ             ==
SYMBOL_NOT                  !
SYMBOL_NOTEQ                !=
SYMBOL_GREATER              >
SYMBOL_GREATEREQ            >=
SYMBOL_LESS                 <
SYMBOL_LESSEQ               <=
SYMBOL_SEMICOLON            ;
SYMBOL_DOT                  .
SYMBOL_DIVISION             /
SYMBOL_MULTIPLICATION       *
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;

class Yytoken {
  public int type;
  public Object value;
  public Yytoken(int type) {
    this.type = type;
  }
  public Yytoken(int type, Object value) {
    this.type = type;
    this.value = value;
  }
    @Override
    public String toString() {
        return this.value.toString();
    }
}
%%
%unicode

%{
public static Boolean stringLiteralInvolved = false;
public static void checkIfInt(String supposedInteger){
     if(!stringLiteralInvolved){
        try {
            int number = Integer.parseInt(supposedInteger);
            if(number < -32768){
             System.out.println("ERROR"); 
             System.exit(0);
            }
            else if (number > 32767) {
             System.out.println("ERROR"); 
             System.exit(0);
            }
        }
        catch(Exception e){
           System.out.println("ERROR");
           System.exit(0);
          }
      }    
}

%}

DIGIT = [0-9]
LETTER =  [:jletter:]
LETTERDIGIT = [:jletterdigit:]
WHITESPACE = [\040\ n] | [ \t]+ | [\t]+
INTEGER = 0 | [1-9][0-9]* | -[1-9][0-9]*
IDENTIFIER = [:jletter:] [:jletterdigit:]*
STRINGLITERAL = \"(\\.|[^\"\\])*\"           
STRINGWITHESCAPEDCHARACTERS = \".*\\.*\"
SYMBOL_LESS = <
SYMBOL_LESSEQ = <=
SYMBOL_GREATER = >
SYMBOL_GREATEREQ = >=
RESERVED_RETURN = return
RESERVED_FOR = for
COMMENT = \/\/+{LETTERDIGIT}* | ##+{LETTERDIGIT}* | ##+{WHITESPACE}*.* | \/\/+{WHITESPACE}*.*
NEWLINE = \n
SYMBOL_MINUS = \-
SYMBOL_PLUS = \+
SYMBOL_DIVISION = \/
SYMBOL_MULTIPLICATION = \*
SYMBOL_EQ = =
SYMBOL_DOUBLEEQ = ==
SYMBOL_NOT = \!
SYMBOL_NOTEQ = \!=
RESERVED_IF = if
RESERVED_THEN = then
RESERVED_ELSE = else
RESERVED_OR = or
RESERVED_STRUCT = struct
RESERVED_BOOL = bool
RESERVED_TRUE = true
RESERVED_FALSE = false
RESERVED_VOID = void
RESERVED_PRINTF = printf
RESERVED_NOT = not
RESERVED_MOD = mod
RESERVED_AND = and
RESERVED_FOR = for
SYMBOL_BRACKET_START = \(
SYMBOL_BRACKET_END = \)
SYMBOL_CURLYBRACKET_START = \{
SYMBOL_CURLYBRACKET_END = \}
RESERVED_INT = int
RESERVED_STRING = string
SYMBOL_SEMICOLON = ;
INVALIDINT = {DIGIT}+{LETTER}+
COMMA = ,
SYMBOL_DOT = .

%state STRING

%%

<YYINITIAL> {
{INVALIDINT}                      { System.out.println("ERROR"); System.exit(0);}
{COMMENT}                         { /* ignore */ }
{SYMBOL_SEMICOLON}                { return new Yytoken(ToYLexer.SYMBOL_SEMICOLON);}
{RESERVED_INT}                    { return new Yytoken(ToYLexer.RESERVED_INT); }
{RESERVED_STRING}                 { return new Yytoken(ToYLexer.RESERVED_STRING); }
{RESERVED_STRUCT}                 { return new Yytoken(ToYLexer.RESERVED_STRUCT); }
{RESERVED_FOR}                    { return new Yytoken(ToYLexer.RESERVED_FOR); }
{RESERVED_THEN}                   { return new Yytoken(ToYLexer.RESERVED_THEN); }
{RESERVED_IF}                     { return new Yytoken(ToYLexer.RESERVED_IF); }
{RESERVED_ELSE}                   { return new Yytoken(ToYLexer.RESERVED_ELSE); }
{RESERVED_OR}                     { return new Yytoken(ToYLexer.RESERVED_OR); }
{RESERVED_BOOL}                   { return new Yytoken(ToYLexer.RESERVED_BOOL); }
{RESERVED_TRUE}                   { return new Yytoken(ToYLexer.RESERVED_TRUE); }
{RESERVED_FALSE}                  { return new Yytoken(ToYLexer.RESERVED_FALSE); }
{RESERVED_VOID}                   { return new Yytoken(ToYLexer.RESERVED_VOID); }
{RESERVED_PRINTF}                 { return new Yytoken(ToYLexer.RESERVED_PRINTF); }
{RESERVED_NOT}                    { return new Yytoken(ToYLexer.RESERVED_NOT); }
{RESERVED_MOD}                    { return new Yytoken(ToYLexer.RESERVED_MOD); }
{RESERVED_AND}                    { return new Yytoken(ToYLexer.RESERVED_AND); }
{RESERVED_RETURN}                 { return new Yytoken(ToYLexer.RESERVED_RETURN); }
{SYMBOL_BRACKET_START}            { return new Yytoken(ToYLexer.SYMBOL_BRACKET_START); }
{SYMBOL_BRACKET_END}              { return new Yytoken(ToYLexer.SYMBOL_BRACKET_END); }
{SYMBOL_CURLYBRACKET_START}       { return new Yytoken(ToYLexer.SYMBOL_CURLYBRACKET_START); }
{SYMBOL_CURLYBRACKET_END}         { return new Yytoken(ToYLexer.SYMBOL_CURLYBRACKET_END); }
{IDENTIFIER}                      { return new Yytoken(ToYLexer.IDENTIFIER, yytext()); }
{NEWLINE}                         { /* ignore */ }
{STRINGWITHESCAPEDCHARACTERS}     { System.out.println("ERROR"); System.exit(0); }
{STRINGLITERAL}                   { stringLiteralInvolved = !stringLiteralInvolved; return new Yytoken(ToYLexer.STRINGLITERAL); }
{INTEGER}                         { checkIfInt(yytext()); return new Yytoken(ToYLexer.INTEGER, yytext()); }
{SYMBOL_EQ}                       { return new Yytoken(ToYLexer.SYMBOL_EQ); }
{SYMBOL_DOUBLEEQ}                 { return new Yytoken(ToYLexer.SYMBOL_DOUBLEEQ); }
{SYMBOL_NOT}                      { return new Yytoken(ToYLexer.SYMBOL_NOT); }
{SYMBOL_NOTEQ}                    { return new Yytoken(ToYLexer.SYMBOL_NOTEQ); }
{SYMBOL_MINUS}                    { return new Yytoken(ToYLexer.SYMBOL_MINUS); }
{SYMBOL_PLUS}                     { return new Yytoken(ToYLexer.SYMBOL_PLUS); }
{SYMBOL_DIVISION}                 { return new Yytoken(ToYLexer.SYMBOL_DIVISION); }
{SYMBOL_MULTIPLICATION}           { return new Yytoken(ToYLexer.SYMBOL_MULTIPLICATION); }
{SYMBOL_LESS}                     { return new Yytoken(ToYLexer.SYMBOL_LESS); }
{SYMBOL_LESSEQ}                   { return new Yytoken(ToYLexer.SYMBOL_LESSEQ); }
{SYMBOL_GREATER}                  { return new Yytoken(ToYLexer.SYMBOL_GREATER); }
{SYMBOL_GREATEREQ}                { return new Yytoken(ToYLexer.SYMBOL_GREATEREQ); }
{WHITESPACE}                      { /* ignore */ }
{COMMA}                           {  return new Yytoken(ToYLexer.COMMA); }
{SYMBOL_DOT}                      { return new Yytoken(ToYLexer.SYMBOL_DOT); }
<<EOF>>                           { return new Yytoken(ToYLexer.END_OF_FILE);}
}