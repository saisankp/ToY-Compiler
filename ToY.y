%define api.prefix {ToY}
%define api.parser.class {ToY}
%define api.parser.public
%define parse.error verbose
%define api.value.type {Yytoken}



%code imports{
  import java.io.InputStream;
  import java.io.InputStreamReader;
  import java.io.Reader;
  import java.io.IOException;
  import java.util.Objects;
  import java.util.*;
}



%code {
  public static SymbolTable symbolTable = new SymbolTable();
  public static String declarationType = "";
  public static String assignmentType = "";
  public static boolean atleastOneProcedure = false;
  public static Hashtable<String, String> declarationsInStruct = new Hashtable<>();
  public static ArrayList<String> structAccessVariables = new ArrayList<>();
  public static String methodDefinitionReturnType = "";
  public static String functionReturnType = "";
  public static boolean returnIncluded = false;
  
  public static void main(String args[]) throws IOException {
    ToYLexer lexer = new ToYLexer(System.in);
    ToY parser = new ToY(lexer);
    if(parser.parse()){
      if(!atleastOneProcedure){
        System.out.println("ERROR");
        System.exit(0);
      }
      System.out.println("VALID");
    }
    else{
      System.out.println("ERROR");
    }
    return;
  }
}


%token SYMBOL_SEMICOLON
%token RESERVED_INT
%token RESERVED_STRING
%token RESERVED_STRUCT
%token RESERVED_FOR
%token RESERVED_RETURN
%token RESERVED_THEN
%token RESERVED_IF
%token RESERVED_ELSE
%token RESERVED_OR
%token RESERVED_BOOL
%token RESERVED_TRUE
%token RESERVED_FALSE
%token RESERVED_VOID
%token RESERVED_PRINTF
%token RESERVED_NOT
%token RESERVED_MOD
%token RESERVED_AND
%token SYMBOL_BRACKET_START
%token SYMBOL_BRACKET_END
%token SYMBOL_CURLYBRACKET_START
%token SYMBOL_CURLYBRACKET_END
%token IDENTIFIER
%token STRINGLITERAL
%token INTEGER
%token SYMBOL_EQ
%token SYMBOL_DOUBLEEQ
%token SYMBOL_NOT
%token SYMBOL_NOTEQ
%token SYMBOL_MINUS
%token SYMBOL_PLUS
%token SYMBOL_DIVISION
%token SYMBOL_MULTIPLICATION
%token SYMBOL_LESS
%token SYMBOL_LESSEQ
%token SYMBOL_GREATER
%token SYMBOL_GREATEREQ
%token SYMBOL_DOT
%token COMMA
%token END_OF_FILE 0 "end-of-file"

%nterm <Yytoken> string_op
%nterm <Yytoken> int_expression2
%nterm <Yytoken> left_expression
%nterm <Yytoken> type
%nterm <Yytoken> type2
%nterm <Yytoken> procedure
%nterm <Yytoken> struct
%nterm <Yytoken> statement
%nterm <Yytoken> return_type

%type<Yytoken> SYMBOL_PLUS
%type<Yytoken> INTEGER
%type<Yytoken> SYMBOL_BRACKET_START
%type<Yytoken> SYMBOL_MINUS
%type<Yytoken> RESERVED_BOOL
%type<Yytoken> RESERVED_STRING
%type<Yytoken> RESERVED_STRUCT
%type<Yytoken> RESERVED_VOID
%type<Yytoken> RESERVED_FOR
%type<Yytoken> RESERVED_IF
%type<Yytoken> RESERVED_PRINTF
%type<Yytoken> RESERVED_RETURN
%type<Yytoken> SYMBOL_CURLYBRACKET_START
%type<Yytoken> RESERVED_INT
%type<Yytoken> IDENTIFIER
%type<Yytoken> SYMBOL_DOUBLEEQ
%type<Yytoken> SYMBOL_NOTEQ
%type<Yytoken> SYMBOL_SEMICOLON
%type<Yytoken> SYMBOL_DOT
%type<Yytoken> COMMA

%nonassoc SYMBOL_DOUBLEEQ //The relational and equality operators (e.g. < and ==) are non-associative
%nonassoc SYMBOL_NOTEQ //The relational and equality operators (e.g. < and ==) are non-associative
%nonassoc SYMBOL_GREATER //The relational and equality operators (e.g. < and ==) are non-associative
%nonassoc SYMBOL_LESS //The relational and equality operators (e.g. < and ==) are non-associative
%nonassoc SYMBOL_GREATEREQ //The relational and equality operators (e.g. < and ==) are non-associative
%nonassoc SYMBOL_LESSEQ //The relational and equality operators (e.g. < and ==) are non-associative
%left SYMBOL_DOT //The dot operator is left associative.
%left SYMBOL_PLUS //All of the other binary operators are left associative.
%left SYMBOL_MINUS //All of the other binary operators are left associative & Unary Operators have highest precedence
%left SYMBOL_MULTIPLICATION //All of the other binary operators are left associative.
%left SYMBOL_DIVISION //All of the other binary operators are left associative.
%precedence SYMBOL_NOT //Unary Operators have highest precedence

%%

prog:
  procedure program {atleastOneProcedure = true;}
  | struct prog 
  | 
;

program:
  procedure program 
  | struct program 
  |
;

procedure:
  return_type IDENTIFIER SYMBOL_BRACKET_START declarations SYMBOL_BRACKET_END SYMBOL_CURLYBRACKET_START statement_sequence SYMBOL_CURLYBRACKET_END {symbolTable.newFunction($2.value.toString()); symbolTable.checkReturnType(methodDefinitionReturnType, returnIncluded, functionReturnType); methodDefinitionReturnType = new String(); returnIncluded = false; functionReturnType = new String();}
  ;

struct: 
  RESERVED_STRUCT IDENTIFIER SYMBOL_CURLYBRACKET_START structdeclarations SYMBOL_CURLYBRACKET_END {symbolTable.structDeclared($2.value.toString(), declarationsInStruct); declarationsInStruct=new Hashtable<>();}
  ;

return_type:
  type2
  | RESERVED_VOID {methodDefinitionReturnType = "Void";}
  ;

type2: 
  RESERVED_INT {methodDefinitionReturnType = "Integer";}
  | RESERVED_BOOL {methodDefinitionReturnType = "Boolean";}
  | RESERVED_STRING {methodDefinitionReturnType = "String";}
  | IDENTIFIER {methodDefinitionReturnType = $1.value.toString();}
  ;

type: 
  RESERVED_INT {declarationType = "Integer";}
  | RESERVED_BOOL {declarationType = "Boolean";}
  | RESERVED_STRING {declarationType = "String";}
  | IDENTIFIER {declarationType = $1.value.toString();}
  ;

structdeclarations:
  RESERVED_INT IDENTIFIER {declarationsInStruct.put($2.value.toString(), "Integer"); declarationType = new String();}
  | RESERVED_BOOL IDENTIFIER {declarationsInStruct.put($2.value.toString(), "Boolean"); declarationType = new String();}
  | RESERVED_STRING IDENTIFIER {declarationsInStruct.put($2.value.toString(), "String"); declarationType = new String();}
  | IDENTIFIER IDENTIFIER {declarationsInStruct.put($2.value.toString(), $1.value.toString()); declarationType = new String();}
  | RESERVED_INT IDENTIFIER COMMA structdeclarations {declarationsInStruct.put($2.value.toString(), "Integer"); declarationType = new String();}
  | RESERVED_BOOL IDENTIFIER COMMA structdeclarations {declarationsInStruct.put($2.value.toString(), "Boolean"); declarationType = new String();}
  | RESERVED_STRING IDENTIFIER COMMA structdeclarations {declarationsInStruct.put($2.value.toString(), "String"); declarationType = new String();}
  | IDENTIFIER IDENTIFIER COMMA structdeclarations {declarationsInStruct.put($2.value.toString(), "Struct"); declarationType = new String();}
;

declarations: 
  type IDENTIFIER
  | type IDENTIFIER COMMA declarations
  | 
  ;

statement_sequence:
  statement statement_sequence
  |
  ;

statement : 
  RESERVED_FOR SYMBOL_BRACKET_START IDENTIFIER SYMBOL_EQ expression SYMBOL_SEMICOLON booleanexpressionforparticularcases SYMBOL_SEMICOLON statement SYMBOL_BRACKET_END statement 
  | RESERVED_IF SYMBOL_BRACKET_START booleanexpressionforparticularcases SYMBOL_BRACKET_END RESERVED_THEN statement
  | RESERVED_IF SYMBOL_BRACKET_START booleanexpressionforparticularcases SYMBOL_BRACKET_END RESERVED_THEN statement RESERVED_ELSE statement
  | RESERVED_PRINTF SYMBOL_BRACKET_START STRINGLITERAL SYMBOL_BRACKET_END SYMBOL_SEMICOLON
  | RESERVED_RETURN expression2 SYMBOL_SEMICOLON {returnIncluded = true;}
  | SYMBOL_CURLYBRACKET_START statement_sequence SYMBOL_CURLYBRACKET_END
  | type IDENTIFIER SYMBOL_SEMICOLON {symbolTable.declarationMade($2.value.toString(), declarationType);}
  | left_expression SYMBOL_EQ expression SYMBOL_SEMICOLON {symbolTable.accessingStructVariableReference(structAccessVariables, assignmentType); structAccessVariables = new ArrayList<>();}
  | IDENTIFIER SYMBOL_EQ expression SYMBOL_SEMICOLON {symbolTable.assignmentMade($1.value.toString(), assignmentType); assignmentType= new String();}
  | IDENTIFIER SYMBOL_BRACKET_START expression_sequence SYMBOL_BRACKET_END SYMBOL_SEMICOLON
  | IDENTIFIER SYMBOL_EQ IDENTIFIER SYMBOL_BRACKET_START expression_sequence SYMBOL_BRACKET_END SYMBOL_SEMICOLON
  ;

expression:
  INTEGER {assignmentType = "Integer";}
  | RESERVED_TRUE {assignmentType = "Boolean";}
  | RESERVED_FALSE {assignmentType = "Boolean";}
  | STRINGLITERAL {assignmentType = "String";}
  | bool_expression {assignmentType = "Boolean";}
  | int_expression {assignmentType = "Integer"; if(structAccessVariables.size()!=0){System.out.println("ERROR"); System.exit(0);} }
  | string_expression {assignmentType = "String"; }
  | bool_expression2 bool_op bool_expression2 {assignmentType = "Boolean";}
  | int_expression2 int_op int_expression2 {assignmentType = "Integer";}
  | string_expression2 string_op string_expression2 {assignmentType = "String";}
  ;

expression2:
  INTEGER {functionReturnType = "Integer";}
  | RESERVED_TRUE {functionReturnType = "Boolean";}
  | RESERVED_FALSE {functionReturnType = "Boolean";}
  | STRINGLITERAL {functionReturnType = "String";}
  | bool_expression {functionReturnType = "Boolean";}
  | int_expression {functionReturnType = "Integer";}
  | string_expression {functionReturnType = "String";}
  | bool_expression2 bool_op bool_expression2 {functionReturnType = "Boolean";}
  | int_expression2 int_op int_expression2 {functionReturnType = "Integer";}
  | string_expression2 string_op string_expression2 {functionReturnType = "String";}
  | IDENTIFIER {functionReturnType = "String";}
  ;

booleanexpressionforparticularcases:
   RESERVED_TRUE { functionReturnType = "Boolean";}
  | RESERVED_FALSE { functionReturnType = "Boolean";}
  | bool_expression { functionReturnType = "Boolean";}
  | bool_expression2 bool_op bool_expression2 { functionReturnType = "Boolean";}
  | int_expression2 int_op2 int_expression2 { functionReturnType = "Integer";}
  ;


int_expression2:
  INTEGER {}
  | SYMBOL_MINUS int_expression
  | left_expression
  | SYMBOL_BRACKET_START int_expression SYMBOL_BRACKET_END
  ;

int_expression:
  INTEGER {}
  | int_expression int_op int_expression
  | SYMBOL_MINUS int_expression
  | left_expression
  | SYMBOL_BRACKET_START int_expression SYMBOL_BRACKET_END
  ;

bool_expression2:
  RESERVED_TRUE
  | RESERVED_FALSE
  | bool_expression bool_op bool_expression
  | SYMBOL_NOT bool_expression
  | SYMBOL_BRACKET_START bool_expression SYMBOL_BRACKET_END
  ;

bool_expression:
  RESERVED_TRUE
  | RESERVED_FALSE
  | bool_expression bool_op bool_expression
  | SYMBOL_NOT bool_expression
  | left_expression
  | SYMBOL_BRACKET_START bool_expression SYMBOL_BRACKET_END
  ;

string_expression2:
  STRINGLITERAL
  | string_expression string_op string_expression
  | SYMBOL_BRACKET_START string_expression SYMBOL_BRACKET_END
  ;

string_expression:
  STRINGLITERAL
  | string_expression string_op string_expression
  | left_expression
  | SYMBOL_BRACKET_START string_expression SYMBOL_BRACKET_END
  ;

left_expression:
  IDENTIFIER {structAccessVariables.add($1.value.toString());}
  | IDENTIFIER SYMBOL_DOT left_expression  {structAccessVariables.add($1.value.toString());}
  ;

expression_sequence: 
  | expression expression_sequence_tail
  ;

expression_sequence_tail:
  | COMMA expression_sequence_tail
  ;

int_op2:
  SYMBOL_DOUBLEEQ
  | SYMBOL_GREATER
  | SYMBOL_LESS
  | SYMBOL_GREATEREQ
  | SYMBOL_LESSEQ
  ;

int_op:  
  SYMBOL_PLUS 
  | SYMBOL_MINUS 
  | SYMBOL_MULTIPLICATION 
  | SYMBOL_DIVISION 
  | RESERVED_MOD
  | SYMBOL_DOUBLEEQ
  | SYMBOL_GREATER
  | SYMBOL_LESS
  | SYMBOL_GREATEREQ
  | SYMBOL_LESSEQ
  ;

bool_op:
  RESERVED_AND
  | RESERVED_OR
  | RESERVED_NOT
  | SYMBOL_DOUBLEEQ
  | SYMBOL_NOTEQ
  ;

string_op:
  SYMBOL_PLUS
  | SYMBOL_DOUBLEEQ
  | SYMBOL_NOTEQ
  ;


%%

class ToYLexer implements ToY.Lexer {
  InputStreamReader it;
  Yylex yylex;

  public ToYLexer(InputStream is){
    it = new InputStreamReader(is);
    yylex = new Yylex(it);
  }

  @Override
  public void yyerror (String s){
   
  }

@Override
  public Yytoken getLVal() {
    return token;
  }

  Yytoken token;

  @Override
  public int yylex () throws IOException{
    token = yylex.yylex();
    return token.type;
  }
}

