%{
#define YYSTYPE double
#include "calc.tab.h"
#include <math.h>
#include <stdio.h>

extern double yylval;
int debug = 0;

%}

D       [0-9]
S       [a-zA-Z_]
%%
[ \t]+  return SPACE;
{D}+(\.{D}*)?    { sscanf( yytext, "%lf", &yylval ); return NUMBER; }
"+"     return PLUS;
"-"     return MINUS;
"/"     return DIV;
"*"     return MUL;
"("     return OPENBRACKET;
")"     return CLOSEBRACKET;
"ans"   return ANS;
"="     return SET;
{S}({S}|{D})* return VARNAME;
"\n"    return EOLN;
%%
/*
  to verbose lexer use regexp(in emacs syntax):
  return \(.*\); => { printf("\1\n"); \& }
*/
