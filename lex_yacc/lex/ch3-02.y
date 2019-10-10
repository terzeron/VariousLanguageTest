%token NAME NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%%
statement:      
                NAME '=' expression
        |       expression { printf("= %d\n", $1); }
                ;

expression:     
                expression '+' NUMBER { printf("expression $1=%d NUMBER $3=%d\n", $1, $3); $$ = $1 + $3; }
        |       expression '-' NUMBER { printf("expression $1=%d NUMBER $3=%d\n", $1, $3); $$ = $1 - $3; }
        |       expression '*' NUMBER { printf("expression $1=%d NUMBER $3=%d\n", $1, $3); $$ = $1 * $3; }
        |       expression '/' NUMBER { printf("expression %1=%d NUMBER $3=%d\n", $1, $3); if ($3 == 0) { yyerror("divided by zero"); } else { $$ = $1 / $3; } }
        |       '-' expression %prec UMINUS { printf("MINUS expression\n"); $$ = -$2; }
        |       '(' expression ')' { printf("parenthesis expression\n"); $$ = $2; }
        |       NUMBER { printf("NUMBER $1=%d\n", $1); $$ = $1; }
                ;
%%

