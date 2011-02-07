%{
#include <alloca.h>
#include <math.h>
#include <stdlib.h>
#include <stddef.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#define YYSTYPE double

double ans;
char format[20];

%}

%token NUMBER ANS SPACE EOLN
%token PLUS MINUS DIV MUL OPENBRACKET CLOSEBRACKET
%left PLUS MINUS
%left MUL DIV

%%
list:   /* пусто */
        | list EOLN
        | list expr EOLN
          { printf( format , (double) $2 ); ans=$2; }
        ;
expr:   add_expr
        ;
add_expr: mul_expr
        | add_expr PLUS mul_expr  { $$ = $1 + $3; }
        | add_expr MINUS mul_expr { $$ = $1 - $3; }
        ;
mul_expr: unary_expr
        | mul_expr MUL unary_expr { $$ = $1 * $3; }
        | mul_expr DIV unary_expr { $$ = $1 / $3; }
        ;
unary_expr: primary
        | PLUS primary { $$ = $2; }
        | MINUS primary { $$ = -$2; }
        ;
primary: NUMBER { $$ = $1; }
        | ANS { $$ = ans; }
        | OPENBRACKET expr CLOSEBRACKET { $$ = $2; }
        ;
%%

#include <stdio.h>
#include <ctype.h>
char *progname;
double yylval;

main( argc, argv )
char *argv[];
{
  progname = argv[0];
  strcpy(format,"%g\n");
  yyparse();
}

yyerror( s )
char *s;
{
  warning( s , ( char * )0 );
  yyparse();
}

warning( s , t )
char *s , *t;
{
  fprintf( stderr ,"%s: %s\n" , progname , s );
  if ( t )
    fprintf( stderr , " %s\n" , t );
}
