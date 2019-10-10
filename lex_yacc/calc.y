%{
#define YYSTYPE double
#include <stdio.h>
#include <ctype.h>
#include <math.h>
%}

/* bison declaration */
%token NUM
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'

%%
input: 
       | input line
;

line:	'\n'
	| exp '\n' { printf("%0.10g\n", $1); }
;

exp: NUM	{ $$ = $1; }
     | exp '+' exp { $$ = $1 + $3; }
     | exp '-' exp { $$ = $1 - $3; }
     | exp '*' exp { $$ = $1 * $3; }
     | exp '/' exp { $$ = $1 / $3; }
     | '-' exp %prec NEG { $$ = -$2; }
     | exp '^' exp { $$ = pow($1, $2); }
     | '(' exp ')' { $$ = $2; }
;
%%


yyerror(char *s)
{
    printf("%s\n", s);
}


yylex()
{
    int c;

    // 공백이나 탭은 읽어 버림
    while ((c = getchar()) == ' ' || c == '\t')
	;
    
    // 소수점이거나 숫자이면 여기서부터 yylval에 읽어들이고 NUM을 반환
    if (c == '.' || isdigit(c)) {
	ungetc(c, stdin);
	scanf("%lf", &yylval);
	return NUM;
    }

    // EOF이면 종료
    if (c == EOF) {
	return 0;
    }

    // 한 글자 반환
    return c;
}


int main()
{
    yyparse();
    
    return 1;
}
