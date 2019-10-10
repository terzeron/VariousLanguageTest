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

    // �����̳� ���� �о� ����
    while ((c = getchar()) == ' ' || c == '\t')
	;
    
    // �Ҽ����̰ų� �����̸� ���⼭���� yylval�� �о���̰� NUM�� ��ȯ
    if (c == '.' || isdigit(c)) {
	ungetc(c, stdin);
	scanf("%lf", &yylval);
	return NUM;
    }

    // EOF�̸� ����
    if (c == EOF) {
	return 0;
    }

    // �� ���� ��ȯ
    return c;
}


int main()
{
    yyparse();
    
    return 1;
}
