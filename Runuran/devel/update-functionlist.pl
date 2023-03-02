#! /usr/bin/perl

# ---------------------------------------------------------------------------

use strict;
use File::Find;
use Getopt::Std;

# --- Constants -------------------------------------------------------------

my $ur_Vignette = "./inst/doc/src/tab-distributions.tex";
my $package_Rd_file = "./man/Runuran-package.Rd";

my $man_dir = "./man";

# --- Usage -----------------------------------------------------------------

sub usage {
    my $progname = $0;
    $progname =~ s#^.*/##g;
        
    print STDERR <<EOM;

usage: $progname -u

  -u ... update list of 'ur' calls for distributions in vignette
         and package help file 'Runuran-package.Rd'

EOM

    exit -1;
}

# --- Read command line options ---------------------------------------------

my %opts;
getopts('u', \%opts) or usage();
my $update = $opts{'u'};

usage unless $update;

# --- Get list of .Rd files -------------------------------------------------

opendir MAN, $man_dir
    or die "Cannot open directory $man_dir: $!";
my @ur_files = grep { /^ur.*\.Rd/ && -f "$man_dir/$_" } readdir MAN;
rewinddir MAN;
my @new_files = grep { /^.*\.new\.Rd/ && -f "$man_dir/$_" } readdir MAN;
closedir MAN;

# --- Get list of distributions ---------------------------------------------

my %urcont;
my %urdiscr;

my $urmax = "Function";
foreach my $ur (sort @ur_files) {
    my $urcall = $ur;
    $urcall =~ s/\.Rd\s*$//;
    $urmax = $urcall if length($urcall) > length($urmax);
    open UR, "$man_dir/$ur" 
	or die "Cannot open file '$man_dir/$ur' for reading: $!";
    while (<UR>) { 
	chomp;
	next unless $_ =~/^\s*\[Distribution]\s+\-\-\s+(.*)$/;
	my $tmp = $1;
	$tmp =~ /^Sampling Function:\s*(.*)\s*\.\s*\%\%\s*(Continuous|Discrete)\s*$/
	    or die "Format error in '$_'";
	my $distr = $1;
	my $type = $2;
	if ($type eq "Continuous") {
	    $urcont{$urcall} = $distr;
	}
	if ($type eq "Discrete") {
	    $urdiscr{$urcall} = $distr;
	}
	last;
    }
}

my $n_urcont  = scalar keys %urcont;
my $n_urdiscr = scalar keys %urdiscr;

print "# continuous distributions = $n_urcont\n"; 
print "# discrete distributions   = $n_urdiscr\n";

# --- Print list of distributions into vignette -----------------------------

my $urheader = 
    "\\begin{tabbing}\n" .
    "\t\\hspace*{1em}\n" .
    "\t\\= \\code{$urmax}~~\\=\\ldots~~\\=  Distribution \\kill\n" .
    "\t\\> \\emph{Function} \\> \\> \\emph{Distribution} \\\\[1ex]\n";
my $urbottom = 
    "\\end{tabbing}\n";

my $urcont_list = "";
foreach my $ur (sort keys %urcont) {
    $urcont_list .= "\t\\> \\code{$ur}\t\\> \\ldots \\> $urcont{$ur} \\\\\n";
}

my $urdiscr_list = "";
foreach my $ur (sort keys %urdiscr) {
    $urdiscr_list .= "\t\\> \\code{$ur}\t\\> \\ldots \\> $urdiscr{$ur} \\\\\n";
}

open DISTR, ">$ur_Vignette"
    or die "Cannot open file '$ur_Vignette' for writing: $!";
print DISTR
    "\\paragraph{Continuous Univariate Distributions ($n_urcont)}\n\n" .
    $urheader . $urcont_list . $urbottom . "\n";
print DISTR
    "\\paragraph{Discrete Univariate Distributions ($n_urdiscr)}\n\n".
    $urheader . $urdiscr_list . $urbottom . "\n";
close DISTR;

# --- Print list of distributions into package Rd file ----------------------

my $urheader = 
    "  \\tabular{lcl}{ \n" .
    "    \\emph{Function} \\tab \\tab \\emph{Distribution} \\cr\n";
my $urbottom = 
    "  }\n";

$urcont_list = "";
foreach my $ur (sort keys %urcont) {
    $urcont_list .= "    \\code{\\link{$ur}} \\tab \\ldots \\tab $urcont{$ur} \\cr\n";
}

my $urdiscr_list = "";
foreach my $ur (sort keys %urdiscr) {
    $urdiscr_list .= "    \\code{\\link{$ur}} \\tab \\ldots \\tab $urdiscr{$ur} \\cr\n";
}

my $list = 
    "  Continuous Univariate Distributions ($n_urcont):\n\n".
    $urheader . $urcont_list . $urbottom . "\n" .
    "  Discrete Distributions ($n_urdiscr):\n\n".
    $urheader . $urdiscr_list . $urbottom . "\n";

open PACKAGE, "$package_Rd_file"
    or die "Cannot open file '$package_Rd_file' for reading: $!";
my $package;
while (<PACKAGE>) {
    $package .= $_;
}
close PACKAGE; 

my $begin = "  %% -- begin: list of distributions --\s*\n";
my $end   = "  %% -- end: list of distributions --\s*\n";

$package =~ s/($begin)(.*?)($end)/$1$list$3/s
    or die "Cannot find marker for list of distributions";

open PACKAGE, ">$package_Rd_file"
    or die "Cannot open file '$package_Rd_file' for writing: $!";
print PACKAGE $package;
close PACKAGE;

# --- end -------------------------------------------------------------------

exit 0;

# ---------------------------------------------------------------------------

