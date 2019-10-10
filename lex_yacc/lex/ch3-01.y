%{
/* 
bison -d ch3-01.y && flex ch3-01.l && gcc ch03-1.tab.c lex.yy.c -ly -ll -Wall
*/
%}

%token NAME NUMBER

%%
statement:      
                NAME '=' expression
        |       expression { printf("= %d\n", $1); }
                ;

expression:     
                expression '+' NUMBER { printf("expression $1=%d NUMBER $3=%d\n", $1, $3); $$ = $1 + $3; }
        |       expression '-' NUMBER { printf("expression $1=%d NUMBER $3=%d\n", $1, $3); $$ = $1 - $3; }
        |       NUMBER { printf("NUMBER $1=%d\n", $1); $$ = $1; }
                ;
                
