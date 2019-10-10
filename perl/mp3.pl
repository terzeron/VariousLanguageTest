# MP3 file list generator

use DirHandle;
$d = new DirHandle ".";

if (defined $d) {
	while (defined($first = $d->read)) {
		if ($first eq "." or $first eq "..") {
			next;
		}
		if (-d $first) {
			print "### $first ###\n";
			$sub_dir = new DirHandle "$first";
			while (defined($second = $sub_dir->read)) {
				if ($second eq "." or $second eq "..") {
					next;
				}
				print "$second\n";
			}
			printf "\n";
			undef $sub_dir;
		} else {
			print "$first\n";
		}
	}
	undef $d;
}