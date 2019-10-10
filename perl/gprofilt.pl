#!/usr/bin/env perl

while (<>) {
    # standard
    s/std:://g;
    s/__gnu_cxx:://g;
    s/\[not-in-charge\]//g;
    s/\[in-charge\]//g;
    s/allocator\<[^\>]+\> //g;
    s/basic_string\<char, char_traits\<char\>, \>/string/g;
    s/basic_string\<char, char_traits\<char\>, allocator\<char\> \>/string/g;
    s/, allocator\<string \> //g;
    s/, equal_to\<[^\>]+\>//g;
    s/, hash\<[^\>]+\>//g;
    s/__stl_hash_string/hash_string/g;
    s/ const(?!ructor)//g;

    # user defined
    s/__normal_iterator/ITERATOR/g;
    s/__simple_alloc/ALLOC/g;
    s/__uninitialized_copy_aux/COPY/g;
    s/__default_alloc_template/ALLOC_TEMPL/g;
    s/__destroy_aux/DESTROY/g;
    s/__false_type/FALSE_T/g;

    print;
}
