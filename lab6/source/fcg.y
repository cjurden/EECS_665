%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
int yydebug = 1;
char* lastFunction = "";
extern void yyerror( char* );
extern int yylex();
%}

/*********************************************************
 ********************************************************/
%union {
    char* id;
    int intval;
    double dblval;
    float fltval;
    char charval;
    char* strval;
}

%token <id> ID
%token <intval> INTVAL
%token <strval> STRVAL
%token <charval> CHARVAL
%token <dblval> DBLVAL
%token <fltval> FLTVAL
%token EQ
%token NE
%token GE
%token LE
%token GT
%token LT
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token BITOR
%token BITAND
%token BITXOR
%token LSH
%token RSH
%token SET
%token RETURN
%token IF
%token ELSE
%token WHILE
%token VOID
%token CHAR
%token SHORT
%token INT
%token LONG
%token FLOAT
%token DOUBLE
%token PREPROC
%token OR
%token AND
%token SETADD
%token SETSUB
%token SETMUL
%token SETDIV
%token SETMOD
%token SETOR
%token SETAND
%token SETXOR
%token SETLSH
%token SETRSH
%token DO
%token FOR
%token SWITCH
%token CASE
%token DEFAULT
%token CONTINUE
%token BREAK
%token GOTO
%token UNSIGNED
%token TYPEDEF
%token STRUCT
%token UNION
%token CONST
%token STATIC
%token EXTERN
%token AUTO
%token REGISTER
%token SIZEOF



%start top

%%

/*********************************************************
 * The top level parsing rule, as set using the %start
 * directive above.
 ********************************************************/
top :
    |function top
    ;

/*This rule matches a  function in C Program*/
function : func_signature '{' func_body '}'

/*This rule matches a function signature such as int main( int argc, char *argv[] )*/
func_signature : type ID '(' args ')' { printf("%s", $2); printf(";\n"); lastFunction = $2;}

/*Rule to match function's body*/
func_body :
          | declaration func_body
          | statement func_body
          ;

//Rule to define function call
func_call : ID '(' exprs ')' { printf("%s", lastFunction); printf(" -> "); printf("%s",$1); printf(";\n"); }

/*Rule to define declaration*/
declaration : type ID ';';
            | type MUL ID
            | type ID '[' INTVAL ']'
            ;

//Rule to define statement
statement : ID SET expr ';'
          | ID '['INTVAL']' SET expr ';'
          | '{' stmnts '}'
          | RETURN expr ';'
          | func_call ';'
          | IF '(' expr ')' statement ELSE statement
          | IF '(' expr ')' statement
          | WHILE '(' expr ')' statement
          ;

args : /* empty rule */
     | parameter
     | parameter ',' args
     ;

parameter : type ID
          | type MUL ID
          | type ID '['']'
          | type MUL ID '['']'
          | type ID '['expr']'
          | type MUL ID '['expr']'
          ;
stmnts  : statement
        | statement ',' stmnts
        ;

expr  : INTVAL
      | STRVAL
      | CHARVAL
      | FLTVAL
      | DBLVAL
      | expr op expr
      | func_call
      | ID
      | MUL ID
      | ID '[' INTVAL ']'
      ;

exprs :
      | expr
      | expr ',' exprs

type  : VOID
      | CHAR
      | SHORT
      | INT
      | LONG
      | FLOAT
      | DOUBLE
      ;

op    : EQ
      | NE
      | GT
      | LT
      | LE
      | GE
      | ADD
      | SUB
      | MUL
      | DIV
      | MOD
      | LSH
      | RSH
      | OR
      | AND
      | BITAND
      | BITOR
      | BITXOR
      | SET
      | SETADD
      | SETSUB
      | SETMUL
      | SETDIV
      | SETMOD
      | SETOR
      | SETAND
      | SETXOR
      | SETLSH
      | SETRSH
      ;

%%

/*********************************************************
 * This method is invoked by the parser whenever an
 * error is encountered during parsing; just print
 * the error to stderr.
 ********************************************************/
void yyerror( char *err ) {
    fprintf( stderr, "at line %d: %s\n", yylineno, err );
}

/*********************************************************
 * This is the main function for the function call
 * graph program. We invoke the parser and return the
 * error/success code generated by it.
 ********************************************************/
int main( int argc, const char *argv[] ) {
    printf( "digraph funcgraph {\n" );
    int res = yyparse();
    printf( "}\n" );

    return res;
}
