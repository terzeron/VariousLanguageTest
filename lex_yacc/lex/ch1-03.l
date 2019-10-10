%{
/*
 * identify verb and non-verb
 */
%}

%%

[\t ]+ /* ignore */ ;

is|am|are|were|was|be|being|been|do|does|did|will|would|should|can|could|has|have|go { printf("%s: is a verb\n", yytext); /* flex���� ���� ���� �� ������ ������� ����. is | am | are�� lex���� �������� flex������ ������ ���� */ }

very|simply|gently|calmy|angrily { printf("%s: is an adverb\n", yytext); }

to|from|behind|below|between { printf("%s: is a preposition\n", yytext); }

if|then|and|but|or { printf("%s: is a conjunction\n", yytext); }

their|my|yours|his|her|its { printf("%s: is an adjective\n", yytext); }

I|you|he|she|we|they { printf("%s: is a pronoun\n", yytext); }

[a-zA-Z]+ { printf("%s: is not recognized\n", yytext); }

.|\n { ECHO; }

%%

int main()
{
  yylex();

  return 0;
}

