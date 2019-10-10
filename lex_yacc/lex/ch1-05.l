%{
/* Lexical analyzer */
#include "y.qtab.h"
#define LOOKUP 0
int state;
static int add_word(int type, char *word);
static int lookup_word(char *word);
%}
                                                
%%
\n { state = LOOKUP; }
\.\n { state = LOOKUP; return 0; }
^verb { state = VERB; }
^adj { state = ADJECTIVE; }
^adv { state = ADVERB; }
^prep { state = PREPOSITION; }
^pron { state = PRONOUN; }
^conj { state = CONJUNCTION; }
[a-zA-Z]+ {
    if (state != LOOKUP) {
        add_word(state, yytext);
    } else {
        int type = LOOKUP;
        switch (type = lookup_word(yytext)) {
        case VERB:
        case ADJECTIVE:
        case ADVERB:
        case NOUN:
        case PREPOSITION:
        case PRONOUN:
        case CONJUNCTION:
            return type;
        default:
            printf("%s: don't recognize\n", yytext);
            /* ignore */
        }
    }
}
\.  ;
%%

#include <string.h>

struct word {
  char *word_name;
  int word_type;
  struct word *next;
};

struct word *word_list;

static int add_word(int type, char *word)
{
  struct word *wp;
  
  if (lookup_word(word) != LOOKUP) {
    fprintf(stderr, "%s already defined\n", word);
    return 0;
  }
  
  wp = (struct word *) malloc(sizeof (struct word));
  wp->next = word_list;
  
  wp->word_name = (char *) malloc(strlen(word) + 1);
  strcpy(wp->word_name, word);
  word_list = wp;
  
  return 1;
}


static int lookup_word(char *word)
{
    struct word *wp = word_list;
  
    for ( ; wp; wp = wp->next) {
        if (strcmp(wp->word_name, word) == 0) {
            return wp->word_type;
        }
    }
  
    return 0;
}
