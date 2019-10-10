%{
/*
 * identify verb and non-verb
 */
%}

%%
[\t ]+ /* ignore */ ;
/* flex���� ���� ���� �� ������ ������� ���� */ 
/* is | am | are�� lex���� �������� flex������ ������ ���� */
is|am|are|were|was|be|being|been|do|does|did|will|would|should|can|could|has|have|go { printf("%s: is a verb\n", yytext); };
[a-zA-Z]+ { printf("%s: is not a verb\n", yytext); };
.|\n { ECHO; };
%%

int main()
{
  yylex();

  return 0;
}

