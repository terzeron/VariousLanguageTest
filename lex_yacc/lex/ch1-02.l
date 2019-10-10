%{
/*
 * identify verb and non-verb
 */
%}

%%
[\t ]+ /* ignore */ ;
/* flex에서 다중 선택 간 공백은 허용하지 않음 */ 
/* is | am | are는 lex에서 허용되지만 flex에서는 허용되지 않음 */
is|am|are|were|was|be|being|been|do|does|did|will|would|should|can|could|has|have|go { printf("%s: is a verb\n", yytext); };
[a-zA-Z]+ { printf("%s: is not a verb\n", yytext); };
.|\n { ECHO; };
%%

int main()
{
  yylex();

  return 0;
}


