%{
/* 
   bison -d ch3-03.y && flex ch3-03.l && gcc ch3-03.tab.c lex.yy.c -Wall -ly -ll
*/
double vbltable[26];
%}
                                                                      
%union {
    
    double dval;
                        int vblno;
}
                        
%token <vblno> NAME 
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS
%type <dval> expression
                        
%%
statement_list:  
                statement '\n'
        |       statement_list statement '\n'
                ;

statement:      
                NAME '=' expression { vbltable[$1] = $3; }
        |       expression { printf("= %g\n", $1); }
                ;

expression:     
                '(' expression ')' { printf("parenthesis expression\n"); $$ = $2; }
        |       expression '+' NUMBER { printf("expression $1=%g NUMBER $3=%g\n", $1, $3); $$ = $1 + $3; }
        |       expression '-' NUMBER { printf("expression $1=%g NUMBER $3=%g\n", $1, $3); $$ = $1 - $3; }
        |       expression '*' NUMBER { printf("expression $1=%g NUMBER $3=%g\n", $1, $3); $$ = $1 * $3; }
        |       expression '/' NUMBER { printf("expression $1=%g NUMBER $3=%g\n", $1, $3); if ($3 == 0) { yyerror("divided by zero"); } else { $$ = $1 / $3; } }
        |       '-'expression %prec UMINUS { printf("MINUS expression\n"); $$ = -$2; }
        |       NUMBER { printf("NUMBER $1=%g\n", $1); $$ = $1; }
        |       NAME { $$ = vbltable[$1]; }
                ;
%%
