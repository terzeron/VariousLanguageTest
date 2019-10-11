#include <stdio.h>
#include <string.h>

int main(void)
{
    char* a[] = {"hello", "world", "java", "javax", "music", "cafe", "blog"};

    int i;
    for (i = 0; i < sizeof (a) / sizeof (a[0]); ++i) {
        if (!strncmp(a[i], "java", strlen("java"))) {
            printf("%s\n", a[i]);
        }
    }
    
    return 0;
}
