%{
#define YYSTYPE double
#include "calc.tab.h"
#include <math.h>
#include <stdio.h>

extern double yylval;
int debug = 0;

%}

D       [0-9.]
%%
[ \t]+  return SPACE;
{D}+    { sscanf( yytext, "%lf", &yylval ); return NUMBER ; }
"+"     return PLUS;
"-"     return MINUS;
"/"     return DIV;
"*"     return MUL;
"("     return OPENBRACKET;
")"     return CLOSEBRACKET;
"ans"   return ANS;
"\n"    return EOLN;
