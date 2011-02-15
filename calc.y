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

#include <ccan/htable/htable.h>
#include <ccan/hash/hash.h>
#include <stdio.h>
#include <err.h>
#include <string.h>

double ans;
char format[20];

struct var {
  const char *name;
  double val;
};

struct htable *ht;

static size_t rehash(const void *e, void *unused);
static bool streq(const void *e, void *string);
static void set_var(struct htable *ht, const *name, const double val);
static double get_var(struct htable *ht, const *name);

%}

%union YYSTYPE {
  double val;
  char *string;
}

%type <val> expr set_expr add_expr mul_expr unary_expr primary

%token <val> NUMBER <val> ANS <string> VARNAME SPACE EOLN
%token PLUS MINUS DIV MUL OPENBRACKET CLOSEBRACKET VAR SET
%right SET
%left PLUS MINUS
%left MUL DIV

%%
list:     /*empty*/
        | list EOLN
        | list expr EOLN
          { printf( format , (double) $2 ); ans=$2; }
        ;
expr:     add_expr
        | set_expr
        ;
set_expr: VARNAME SET add_expr {
  set_var(ht, (void*)$1, $3);
  free($1);
  $$ = $3; }
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
primary:  NUMBER { $$ = $1; }
        | ANS { $$ = ans; }
        | VARNAME {$$ = get_var(ht, (void*)$1); free($1); }
        | OPENBRACKET expr CLOSEBRACKET { $$ = $2; }
        ;
%%

#include <stdio.h>
#include <ctype.h>
char *progname;
//double yylval;

// Wrapper for rehash function pointer.
static size_t rehash(const void *e, void *unused)
{
  return hash_string(((struct var *)e)->name);
}

// Comparison function.
static bool streq(const void *e, void *string)
{
  return strcmp(((struct var *)e)->name, string) == 0;
}

//set variable
static void set_var(struct htable *ht, const *name, const double val){
  struct var *n;
  n = htable_get(ht, hash_string((char *)name), streq, name);
  if( n == NULL){
    n = malloc(sizeof(*n));
    n->name = strdup((char*)name);
    n->val = val;

    htable_add(ht, hash_string(n->name), n);
  }else{
    n->val = val;
  }
  
}

//get variable
static double get_var(struct htable *ht, const *name){
  struct var *n;
  n = htable_get(ht, hash_string((char*)name), streq, name);
  if(n != NULL){
    return n->val;
  }else{
    printf("There are no variables with name: %s, use 0.0", (char*)name);
    return 0.;
  }
}

main( argc, argv )
char *argv[];
{
  progname = argv[0];
  strcpy(format,"%g\n");
  ht = htable_new(rehash, NULL);
  
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
