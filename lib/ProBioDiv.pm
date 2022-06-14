package ProBioDiv;
use strict;
use warnings;
use ProBioDiv::Individual;
use ProBioDiv::Marker;
use ProBioDiv::Genotype;
use ProBioDiv::Introgression;
use Getopt::Long;


my $VERSION = "v0.0.1";
my $MAX_SIZE= 2000000;

=head1 Name

ProBioDiv;

=head1 Description

  This class gives tools for working with ProBioDiv Data

=head1 synopsis

use ProBioDiv;

# cree un Individual
my $probiodiv = ProBioDiv::load(data=> "toto", pop=>"tata", species=>"titi");

=cut

#########


#################
# Methode new() #
#################

my %genotypes_bank=();

=head2 new()

 Title    : new()
 Usage    : my $gt = new ProBioDiv::Genotype;
 Function : This function creates a Marker object
 Returns  : A ProBioDiv;;Genotype
 Args     : valued arguments

=cut


sub new() {
	## Variables
	my ( $class, %attrs ) = @_;

	## Object's attributes
	my $pbd = bless {
		'species' => undef,
		'genotypes' => [],
		'individuals' => [],
		'markers'      => [],
		%attrs
	};
	return $pbd;
}

=head2 species()
 Title    : species()
 Usage    : my $sp= $pbd->species() or $pbd->species($sp);
 Function : returns the species of the experiment
 Returns  : a string
 Args     : a string or nothing

=cut

sub species() {
	my $self=shift;
	if (scalar (@_)) {
		$self->{'species'}= shift;
	}
	return $self->{'species'}
}

=head2 markers()

 Title    : markers()
 Usage    : @markers=$pbd->markers() or $pbd->markers(\@markers);
 Function : returns the list of markers analyzed
 Returns  : a list of markers;
 Args     : a list of markers or nothing

=cut

sub markers {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'markers'}= \@_;
	}
	return @{$self->{'markers'}};
}

=head2 individuals()

 Title    : individuals()
 Usage    : @individuals=$pbd->individuals() or $pbd->individuals(\@individuals);
 Function : returns the list of the individuals analyzed
 Returns  : a list of individuals;
 Args     : a list of individuals or nothing

=cut

sub individuals {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'individuals'}= \@_;
	}
	return @{$self->{'individuals'}};
}

=head2 genotypes()

 Title    : genotypes()
 Usage    : @genotypes=$pbd->genotypes() or $pbd->genotype(\@genotypes);
 Function : returns the list of genotypes analyzed
 Returns  : a list of genotypes;
 Args     : a list of genotypes or nothing

=cut

sub genotypes {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'genotypes'}= \@_;
	}
	return @{$self->{'genotypes'}};
}

=head2 populations()

 Title    : populations()
 Usage    : @pops=$pbd->populations() or $pbd->populations(\@pops);
 Function : returns the list of populations stored
 Returns  : a list of populations;
 Args     : a list of population (ids) or nothing

=cut

sub populations {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'populations'}= \@_;
	}
	return @{$self->{'populations'}};
}


=head2 load()

 Title    : load()
 Usage    : my $pbd = ProBioDiv::load('file.txt');
 Function : This function creates a ProBioDiv object
 Returns  : A ProBioDiv object
 Args     : valued arguments

=cut


sub load {
	## Variables

	my %params=(
		file=> undef,
		population => undef,
		species => undef,
		@_
	);
	## Object's attributes
	open FILE, $params{'file'} or die "failed to open $params{'file'}\n";
	my $header = <FILE>;
	chomp $header;
	my @header = split "\t", $header;
	my @individuals=();
	my %selected=();
    my %species=();
	for (my $i =2; $i < scalar(@header); $i++) {
        my ($year,$code,$popnum);
		if ($header[$i] =~ /^A[Vv]/) {
			my $ind=ProBioDiv::Individual->new(name=> $header[$i],species=>'colza', population=>$header[$i]);
			$selected{$ind}=1;
            $species{$ind}='colza';
			push @individuals, $ind;
			next;
		}
		if (($popnum)=$header[$i] =~ /\d+PBD(1[1-9]|20)\-p\d{2}$/) {
		#	print STDERR $header[$i], "\n";
			my $ind=ProBioDiv::Individual->new(name=> $header[$i],species=>'chou', population=>$popnum);
			if ($popnum eq $params{'population'}) {$selected{$ind}=1;}
            else {$selected{$ind}=0}
            $species{$ind}='chou';
			push @individuals, $ind;
			next;
		}
		if (($popnum)=$header[$i] =~ /\d+PBD(0\d|10)\-p\d{2}(B|p\d{2})*$/) {
			#	print STDERR $header[$i], "\n";
				my $ind=ProBioDiv::Individual->new(name=> $header[$i],species=>'navette', population=>$popnum);
                if ($popnum eq $params{'population'}) {$selected{$ind}=1;}
                else {$selected{$ind}=0}
                $species{$ind}='navette';
				push @individuals, $ind;
				next;
		}
#		
        # All other individuals are probiodiv

        if (($year,$code,$popnum)=$header[$i] =~ /^(\d+)(-PRO-|PBD)(\d+)-.+/) {
			#print STDERR "$header[$i] $popnum\n";
            my $ind=ProBioDiv::Individual->new(name=> $header[$i],species=>'pro', population=> $popnum);
            $selected{$ind}=0;
            $species{$ind}='pro';
            if ($popnum eq $params{'population'}) {$selected{$ind}=1;}
            push @individuals, $ind;
            next;
		}
      
		print STDERR ("Error unknown individual : $header[$i]\n");
	}
    

	my @markers=();
	my @genotypes=();
	while (<FILE>) {
			#print;
			chomp;
			my @fields=split "\t";
			my $index = shift @fields;
			my $name = shift @fields;
			my $marker = ProBioDiv::Marker->new(name => $name);
			push @markers, $marker;
			for (my $i=0; $i < scalar(@fields); $i++) {
                if (not defined ($individuals[$i])) {
                    print "$i - $name ", "h :", $header[$i+2], "\n";
                    exit(1);
                }
                if ($selected{$individuals[$i]}==1) {
                 #  print STDERR "Adding ", $marker->name, " ", $individuals[$i]->name, "\n";
                    my $genotype = ProBioDiv::Genotype->new(marker=>$marker, individual=>$individuals[$i], value=>$fields[$i]);
                    $individuals[$i]->add_genotype($genotype);
                    push @{$genotypes_bank{$species{$individuals[$i]}}{$marker->name()}}, $genotype;
                    push @genotypes, $genotype;
                }
			}
			#$individuals[$i]->genotypes(\@genotypes);
	}
    
    # remove the not selected individuals from the individuals table
    my @sel_individuals=();
    foreach my $ind (@individuals){
        if ($selected{$ind}==1) {push @sel_individuals,$ind;}
    }
	return ProBioDiv->new(species=> $params{'species'}, individuals=>\@sel_individuals, markers=>\@markers, genotypes=>\@genotypes);
}

=head2 add_positions()

 Title    : add_position
 Usage    : $pbd->add_position($position);
 Function : this function add the chromosomal position of the markers from a bed file
 Returns  : nothing
 Args     : a bed file

=cut

sub add_positions {
	my $self=shift;
	my $bed=shift;

	open BED, $bed or die "failed to open $bed\n";
	my %chr=();
	my %pos=();
	while (<BED>) {
		chomp;
		my ($marker, $chr, $pos) = split;
		$chr{$marker}=$chr;
		if ($pos eq 'Unknown') {$pos=0}
		$pos{$marker}=$pos;
	}

	foreach my $mrk ($self->markers()) {
		#print STDERR $mrk->name, "\n";
		if (exists $chr{$mrk->name()}) {
			$mrk->chromosome($chr{$mrk->name()});
			$mrk->position($pos{$mrk->name()});
		}
		else {
#			print STDERR "marker ", $mrk-> name(), "not located\n";
			$mrk->chromosome("unknown");
			$mrk->position("NA");
		}
	}
}


=head2 get_genotypes()

Title    : get_genotypes()
Usage    : $pbd->get_genotypes(marker=>$mrk, species=>$species), $pbd;
Function : this function returns the genotypes corresponding to a marker and or a species
Returns  : a list of genotypes
Args     : a hash with marker and species keys

=cut

sub get_genotypes {
	my $self = shift;
	my %params = (
		marker=>undef,
		species => undef,
		@_
	);

	#print STDERR "titit : ", $params{'marker'}->name(), "$params{'species'}\n";
	if ( not defined ($genotypes_bank{$params{'species'}}{$params{'marker'}->name()})) { return ()}
	my @selected_gts=@{$genotypes_bank{$params{'species'}}{$params{'marker'}->name()}};

	# my @genotypes = $self->genotypes();
	# my @selected_gts=();
	# foreach my $gt (@genotypes) {
	# 	#print STDERR $gt->individual->species(), "\n";
	# 	if (defined $params{'marker'}) {next if ($gt->marker()->name() ne $params{'marker'}->name())}
	# 	if (defined $params{'species'}) {next if ($gt->individual->species() ne $params{'species'})}
	# 	push @selected_gts, $gt;
	# }

	return(@selected_gts);
}


=head2 get_introgressions

 Title    : get_introgressions()
 Usage    : my @intro_gt=$pbd->get_introgressions();
 Function : this function returns the genotypes corresponding to a introgression in the colza
 Returns  : a list of genotypes
 Args     : a hash with marker and species keys

=cut

sub get_introgressions {
	my $self=shift;
 	MRK: foreach my $mrk ($self->markers) {
        my @colza_gts=$self->get_genotypes(marker=> $mrk,species=>'colza');
		# We remove NA
		my @good_refs=();
		my $na=0;
		foreach my $gt (@colza_gts) {
			#print STDERR "gt = $gt\n";
			if ($gt->value() eq 'AB') {
				#print STDERR "Heterozygous marker ", $mrk->name(), "\n";
				$mrk->status("HET");
				next MRK;
			}
			if (($gt->value() eq '--') || ($gt->value() eq 'NC')) {
				$na++;
				if ($na > 1) {
					$mrk->status("BAD");
					#print STDERR "Bad marker ", $mrk->name(), "\n";
					next MRK;
				}
				next;
			}
			push @good_refs, $gt;
		}
        
		if (scalar(@good_refs)==0) {
			#print STDERR "No rapeseed genotype for marker ", $mrk->name(), "\n";
			$mrk->status("BAD");
			next MRK;
		}
	 	my $ref=$good_refs[0]->value();
		foreach my $gt (@good_refs) {
			if (($gt->value ne $ref) && (($gt->value ne '--') || ($gt->value() eq 'NC')))
            {
				#print STDERR "Not usable marker :", $mrk->name(), "\n";
				$mrk->status("HET");
				next MRK;
			}
		}

       
        my @dipl_gts=$self->get_genotypes(marker=> $mrk,species=>$self->species());

        my $non_informative=0;
        my $polymorphe=0;

        if (scalar(@dipl_gts) == 0) { # the diploid have not been genotyped
            print STDERR "No diploïd genotypes for ", $mrk->name(),"\n";
            $mrk->status("P"); # We are considering that it is polymorphic
            $polymorphe=1;
        }

        foreach my $gt (@dipl_gts) {
            next if (($gt->value() eq '--') || ($gt->value() eq 'NC'));
            #	print STDERR "val:", $gt->value(), "\n";
                if ($gt->value ne $ref) {
#				print STDERR $mrk->name(), " ref : $ref -- ", "dipl : ", $gt->value(),  "\n";
                    $polymorphe=1;
                    $mrk->status("P");
				if ($gt->value() eq 'AB'){
					$non_informative=1;
				}
			}
			else {
				$non_informative=1;
			}
		}

		# get the descendants

		unless ($polymorphe) {
			#print STDERR $mrk->name(), " is not polymorphic\n";
			$mrk->status("NP");
			next MRK;
		}



		my @desc_gts=$self->get_genotypes(marker=> $mrk,species=>"pro");
		foreach my $gt (@desc_gts) {
			if (($gt->value() eq '--')|| ($gt->value() eq 'NC')) {
				#print STDERR "Non informative : mrk ", $mrk->name(), " ind : ", $gt->individual->name(),"\n";
				$gt->status("Ninf");
				next;
			}
			if ($gt->value ne $ref) {
				#print STDERR "Introgression : mrk ", $mrk->name(), " ind : ", $gt->individual->name(),"\n";
				$gt->status("Int");
				next;
			}
			else {
				if ($non_informative) {
					$gt->status("Ninf");
					#print STDERR "Non informative : mrk ", $mrk->name(), " ind : ", $gt->individual->name(),"\n";
				}

				else {
					$gt->status("Nint");
					#print STDERR "AVISO : mrk ", $mrk->name(), " ind : ", $gt->individual->name(),"\n";
				}
			}
		}
	}
 }


=head2  get_all_chromosomes

Title    : get_all_chromomosomes()
Usage    : my @chrs=$get_all_chromomosomes();
Function : this function returns a list of chromosomes for the study
Returns  : a list of string
Args     : nothing

=cut

sub get_all_chromomosomes{
	my $self = shift;
	my @markers= $self->markers();

	my %chrs=();
	foreach my $mrk (@markers) {
		$chrs{$mrk->chromosome()}=1;
	}

	return sort {$a cmp $b} keys %chrs;
}

=head2 get_markers_by_chromomosomes

Title    : get_markers_by_chromomosomes()
Usage    : my @mrk=$get_markers_by_chromomosomes("chrA01");
Function : this function returns an ordered list of markers on a chromosome
Returns  : a list of markers
Args     : a string

=cut

sub get_markers_by_chromomosomes {
	my $self=shift;
	my $chr=shift;

	my @markers = $self->markers();

	my @sel_mrks=();
	foreach my $mrk (@markers) {
		if ($mrk->chromosome eq $chr) {
			push @sel_mrks, $mrk;
		}
	}
	if  ($chr eq "unknown") {
		return(@sel_mrks);
	}
	return sort {$a->position() <=> $b->position()} @sel_mrks;
}

=head2 marker_info

 Title    : marker_info
 Usage    : $pbd->marker_info();
 Function : this function returns a table with the status of the marker and the counts of genotype of each category (Int, NInf and  NInt)
 Returns  : a table with the status of the marker and the counts of genotype of each category (Int, NInf and  NInt)
 Args     : nothing

=cut

sub marker_info {
	my $self=shift;

	my @chrs = $self->get_all_chromomosomes();
	#print join " ",@chrs, "\n";
	foreach my $chr (@chrs) {
		my @mrks=$self->get_markers_by_chromomosomes($chr);
		foreach my $mrk (@mrks) {
			print join "\t", $chr, $mrk->name(), $mrk->position(), $mrk->status();
			if ($mrk->status() eq 'P') {
				my $ninf=0;
				my $nint=0;
				my $int=0;
				print "\t";
				foreach my $gt ($self->get_genotypes(species=>'pro', marker=>$mrk)) {
					if ($gt->status eq "Ninf") {$ninf++}
					if ($gt->status eq "Nint") {$nint++}
					if ($gt->status eq "Int") {$int++}
				}
				print join "\t", $int, $nint, $ninf;
		}
		print "\n";
		}
	}
}



=head2 introgressions_size

 Title    : introgressions_size()
 Usage    : my @intro_gt=$pbd->introgression_size();
 Function : this function returns the genotypes corresponding to a introgression in the colza
 Returns  : a list of genotypes
 Args     : a hash with max_size (the maximal size of extension of a introgressio)

=cut

sub introgressions_size {
	my $self =shift;
	my %param=(max_size=>$MAX_SIZE,@_);

	my @chrs = $self->get_all_chromomosomes();
	my %mrks=();
	foreach my $chr (@chrs) {
		@{$mrks{$chr}}=$self->get_markers_by_chromomosomes($chr);
	}

	my @ints;
	foreach my $ind ($self->individuals) {
		next unless ($ind->species() eq 'pro');
        #print STDERR "Individual : ", $ind->name(),"\n";
		foreach my $chr(@chrs) {
			my $int=undef;
			foreach my $mrk (@{$mrks{$chr}}) {
				#print STDERR $mrk->status(), "\n";
				next if ($mrk->position eq 'NA');
				if ($mrk->status() eq 'P') {
					my $gt=$ind->get_genotype(marker=>$mrk);
					#print STDERR  "gt:$gt", "\n";
					if ($gt->status() eq "Int") {
						if ((defined ($int)) && (($mrk->position() - $int->end()->position()) < $param{"max_size"})) {
								$int->end($mrk);
								$int->nb_inf_mrks($int->nb_inf_mrks()+1);
						}
						else {
							$int=ProBioDiv::Introgression->new(individual=>$ind, chr=>$chr, start=>$mrk, end=>$mrk);
							$int->nb_inf_mrks(1);
							push @ints, $int;
						}
					}
					if ($gt->status() eq "Nint") {
						$int=undef;
					}
					if ($gt->status() eq "Ninf") {
						if (defined $int) {
							if (($mrk->position() - $int->end()->position()) > $param{"max_size"}) {
								$int=undef;
							}
							else {
								$int->nb_ninf_mrks($int->nb_ninf_mrks()+1);
							}
						}
					}
				}
			}
		}
	}

	foreach my $int (@ints) {
		if (($int->start->position() ne 'NA') && ($int->end->position() ne 'NA')) { 
			print join ("\t", $int->individual->name(), $int->chr(), $int->start()->name().' ('.$int->start->position().')',  $int->end()->name().' ('.$int->end->position().')', $int->end->position()-$int->start->position(), $int->nb_inf_mrks, $int->nb_ninf_mrks), "\n";
		}
		else {
			print join ("\t", $int->individual->name(), $int->chr(), $int->start()->name().' ('.$int->start->position().')',  $int->end()->name().' ('.$int->end->position().')', 'NA', $int->nb_inf_mrks, $int->nb_ninf_mrks), "\n";
		}	
	}
}



=head2 markers_ind

 Title    : markers_ind()
 Usage    : $pbd->markers_ind();
 Function : this function prints for each markers the status of each indvidual
 Returns  : none
 Args     : none

=cut

sub markers_ind {
	my $self =shift;

	print "Chromosome\tMarker\tPosition\tStatus";
	foreach my $ind ($self->individuals) {
			next unless ($ind->species() eq 'pro');
			print "\t", $ind->name();
	}
	print "\n";

	my @chrs = $self->get_all_chromomosomes();
	foreach my $chr (@chrs) {
		foreach my $marker ($self->get_markers_by_chromomosomes($chr)) {
			print join "\t", $chr, $marker->name, $marker->position, $marker->status;
			foreach my $ind ($self->individuals) {
				next unless ($ind->species() eq 'pro');
				my $gt=$ind->get_genotype(marker=>$marker);
                if (not defined $gt) {print STDERR $marker->name(), " not genotyped for ", $ind->name(), "\n";}
				if (defined $gt->status()) {print "\t", $gt->status()}
				else {print "\tundef"}
			}
			print "\n";
		}
	}
}


1;
