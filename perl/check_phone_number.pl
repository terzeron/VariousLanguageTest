#!/usr/bin/env perl

use strict;
use warnings;
use English;


sub is_definite_phone_number
{
    my $str = shift;

    # 국제전화 001-XXX-XXXX, 00700-XXX-XXXX
    if ($str =~ /^00[124-689]\d{7,8}$/o or
        $str =~ /^00[37]\d{9,10}$/o) {
        return 1;
    }
    # 이동통신 및 부가통신망 010-XXX-XXXXX, 013X-XXX-XXXX, 014XX-XXX-XXXX
    if ($str =~ /^01[0-25-9]\d{7,8}$/o or
        $str =~ /^013\d{8,9}$/o or
        $str =~ /^014\d{9,10}$/o) {
        return 1;
    }
    # 공통 서비스 020-XXX-XXXX, 070-XXX-XXXX
    if ($str =~ /^0[2-9]0\d{7,8}$/o) {
        return 1;
    }
    # 지역 번호 031-XXX-XXXX
    if ($str =~ /^02\d{7,8}$/o or
        $str =~ /^0(3[1-3]|4[1-3]|5[1-5]|6[1-4])\d{7,8}$/o) {
        return 1;
    }
    # 시외전화 081-XXX-XXXX, 085XX-XXX-XXXX
    if ($str =~ /^08[1-46-8]\d{7,8}$/o or
        $str =~ /^085\d{9,10}$/o) {
        return 1;
    }
    # 평생전화 050X-XXX-XXXX
    if ($str =~ /^050[2456]\d{7,8}$/o) {
        return 1;
    }
    # 공공기관 13XX-XXXX
    if ($str =~ /^13\d{6}$/o) {
        return 1;
    }
    # 부가서비스 15XX-XXXX
    if ($str =~ /^1[56]\d{6}$/o) {
        return 1;
    }
    # 700
    if ($str =~ /^700\d{4}$/o) {
        return 1;
    }

    return 0;
}


sub check_phone_number
{
    my $str = shift;
    my $count =  0;

    my @str_list = split /\b|  |\t/, $str;
    push @str_list, $str;
    foreach my $a_str (@str_list) {
        if ($a_str =~ /(\d(\d+|[\:\-\)\(\_\=\+\.\, ])*\d)/o) {
            my $number_str = $1;
            my @char_list = split //, $number_str;
            foreach my $char (@char_list) {
                if ($char =~ /\d/) {
                    ++$count;
                }
            }
            if ($count >= 7) {
                (my $pure_number_str = $number_str) =~ s/\D//g;
                if (is_definite_phone_number($pure_number_str) == 1) {
                    return 1;
                }
                if ($number_str =~ /^\d{3,4}-\d{4}$/o) {
                    return 1;
                }
            }
        }
    }

    return 0;
}


sub main
{
    print check_phone_number("267478713") . "\n";
    print check_phone_number("674-7813") . "\n";
    print check_phone_number("042") . "\n";
    print check_phone_number("032)422-0247") . "\n";
}


main();
