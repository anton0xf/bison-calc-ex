%{
  /*
    simple calculator example based on flex/bison
    Copyright (C) 2011  anton0xf <anton0xf@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */

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

%token NUMBER ANS VARNAME SPACE EOLN
%token PLUS MINUS DIV MUL OPENBRACKET CLOSEBRACKET SET
%right SET
%left PLUS MINUS
%left MUL DIV

%%
list:     /*empty*/
        | list EOLN
        | list expr EOLN
          { printf( format , (double) $2 ); ans=$2; }
        ;
delim:    /*empty*/
        | SPACE
	;
expr:     add_expr
        | set_expr
        ;
set_expr: VARNAME set add_expr { $$ = $3 }
        ;
set:      delim SET delim
        ;
add_expr: mul_expr
        | add_expr plus mul_expr  { $$ = $1 + $3; }
        | add_expr minus mul_expr { $$ = $1 - $3; }
        ;
plus:     delim PLUS delim
        ;
minus:    delim MINUS delim
        ;
mul_expr: unary_expr
        | mul_expr mul unary_expr { $$ = $1 * $3; }
        | mul_expr div unary_expr { $$ = $1 / $3; }
        ;
mul:      delim MUL delim
        ;
div:      delim DIV delim
        ;
unary_expr: primary
        | PLUS primary { $$ = $2; }
        | MINUS primary { $$ = -$2; }
        ;
primary:  delim NUMBER delim { $$ = $2; }
        | delim ANS delim { $$ = ans; }
        | openbracket expr closebracket { $$ = $2; }
        ;
openbracket: delim OPENBRACKET delim
        ;
closebracket: delim CLOSEBRACKET delim
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
