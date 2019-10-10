#!/usr/bin/env perl

sub get_file_name
{
    my $SECONDS_PER_DAY = 60 * 60 * 24;
    my $eTime;
    my $file_name;

    $eTime = time - $SECONDS_PER_DAY * $_[0];
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
        localtime($eTime);
    $year -= 100;
    $mon += 1;
    $file_name = sprintf("%02d%02d%02d", $year, $mon, $mday);
    return $file_name;
}

my $i;
my $date_str1;
my $date_str2;
my $cmd;
my $result;
my $j;
my $date_str;
my $num_days = 60;
my $previous_file = "";
my $new_file = "";
my $threshold = $ARGV[0];

print "=== $threshold ===\n";
print "date\t\tnew-pair\tnew-unique\ttotal-repr\n";
$previous_file = "";
for ($i = $num_days; $i >= 0; --$i) {
    $date_str1 = get_file_name($i + 1);
    $date_str2 = get_file_name($i + 2);
    #print "$date_str2 --> $date_str1: ";
    
    $cmd = "awk -F '\\t' '\$2 >= $threshold { print \$0 }' ";
    $cmd .= "$previous_file $date_str2.result ";
    $new_file = "$date_str2.result.tmp.$threshold";
    $cmd .= "> $new_file";
    #print "$cmd\n";
    $previous_file = $new_file;
    $result = `$cmd`;
    #print $result;

    print $date_str1 . "\t\t";
    
    $cmd = "~/terzeron/countnewcombi.pl ${date_str2}.result.tmp.$threshold ${date_str1}.result $threshold";
    $result = `$cmd`;
    chomp $result;
    print $result . "\t\t";

    $cmd = "~/terzeron/countnewunique.pl ${date_str2}.result.tmp.$threshold ${date_str1}.result $threshold";
    $result = `$cmd`;
    chomp $result;
    print $result . "\n";
}
