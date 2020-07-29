use strict;
use warnings;
use Getopt::Long;
use ProBioDiv;

my ($popfile, $population, $species, $position);

my $max_size=1000000;

 GetOptions ("popfile=s" => \$popfile,
            "population=s"   => \$population,
            "species=s" => \$species,
            "position=s" => \$position,
            "max_size=i" => \$max_size);

my $pbd = ProBioDiv::load(file => $popfile, population => $population, species => $species);
$pbd->add_positions($position);

# Find introgressions
#oreach my $gt ($pbd->genotypes) {
 # print STDERR join (" ", $gt->individual->name(), $gt->marker()->name,  $gt->marker()->chromosome, $gt->marker()->position, $gt->value()), "\n";
#}

$pbd->get_introgressions();
$pbd->markers_ind();
