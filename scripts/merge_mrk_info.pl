use strict;
use warnings;

my $file = shift;

my %files=();
open FILE, $file or die "failed to open $file\n";
my @pops=();
while (<FILE>) {
  chomp;
  my ($pop, $file) = split;
  $files{$pop}=$file;
  push @pops, $pop;
}

my @mrk=();
my %chr=();
my %pos=();
my %mrk_status=();
my %int=();
my %nint=();
my %ninf=();

my %sum_int=();
my %sum_nint=();
my %sum_ninf=();

my $first=1;
foreach my $pop (@pops) {
  open FILE, $files{$pop} or die "failed to open $files{$pop}\n";
  while (<FILE>) {
    chomp;
    my ($chr, $mrk, $pos, $mrk_status, $int, $nint, $ninf) = split;

    if ($first) {
      $chr{$mrk}=$chr;
      $pos{$mrk}=$pos;
      push @mrk,$mrk;
      $sum_int{$mrk}=0;
      $sum_nint{$mrk}=0;
      $sum_ninf{$mrk}=0;
    }

    $mrk_status{$pop}{$mrk}=$mrk_status;

    if ($mrk_status eq "P") {
      $int{$pop}{$mrk}=$int;
      $nint{$pop}{$mrk}=$nint;
      $ninf{$pop}{$mrk}=$ninf;
      $sum_int{$mrk}+=$int;
      $sum_nint{$mrk}+=$nint;
      $sum_ninf{$mrk}+=$ninf;
    }
    else {
      $int{$pop}{$mrk}=0;
      $nint{$pop}{$mrk}=0;
      $ninf{$pop}{$mrk}=0;
    }
  }
  $first=0;
}

# Header
print join "\t", "Chromosome", "Marker", "Position";
foreach my $pop (@pops) {
  print "\tMarker status ($pop)";
  print "\t# introgressions ($pop)";
  print "\t# non introgressions ($pop)";
  print "\t# non informative ($pop)";
}
print "\tSum introgressions";
print "\tSum non introgressions";
print "\tSum non informative";
print "\n";

foreach my $mrk (@mrk) {
  print join "\t",$chr{$mrk}, $mrk,  $pos{$mrk};
  foreach my $pop (@pops) {
    print "\t", $mrk_status{$pop}{$mrk};
    print "\t", $int{$pop}{$mrk};
    print "\t", $nint{$pop}{$mrk};
    print "\t", $ninf{$pop}{$mrk};
  }
  print "\t", $sum_int{$mrk};
  print "\t", $sum_nint{$mrk};
  print "\t",  $sum_ninf{$mrk};
  print "\n";
}
