%{
#include "ch03-1.tab.h"
extern int yylval;
%}

%%
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[ \t]+ /* ignore */ ;
\n return 0; 
. return yytext[0];
%%

