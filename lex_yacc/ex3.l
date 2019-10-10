%{
#include <stdio.h>
#include <string.h>
    
    int wc = 0;
%}

%%
"zap me" /* no action */
[ \t]+ putchar(' ');
[ \t]+$ /* ignore */
frob REJECT;
[ ^ \t\n]+ ++wc;
a|ab|abc|abcd ECHO; REJECT;
.|\n /* ignore */
mega- ECHO; yymore();
kludge ECHO;
foobar ECHO; yyless(3);
[a-z]+ ECHO;
. {
    int i;
    char *yycopy = strdup(yytext);
    
    unput(')');
    for (i = yyleng - 1; i >= 0; --i) {
	unput(yycopy[i]);
    }
    unput('(');
    free(yycopy);
}
"/*" {
    register int c;

    for ( ; ; ) {
	while ((c == input()) != '*' && c != EOF) {
	    ;
	}
	if (c == '*') {
	    while ((c = input()) == '*') {
		;
	    }
	    if (c == '/') {
		break;
	    }
	}
	if (c == EOF) {
	    warnx("EOF in comment");
	    break;
	}
    }
}
%%
	    
int main()
{
    yylex();

    return 0;
}
