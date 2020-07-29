package ProBioDiv::Individual;
use strict;
use warnings;

my $VERSION = "v0.0.1";
=head1 Name

ProBioDiv::Individual;

=head1 Description

  This class describes an individual with its name, population and species

=head1 synopsis

use ProBioDiv::Individual;

# cree un Individual
my $ind = new ProBioDiv::Individual(name=> "toto", pop=>"tata", species=>"titi");

=cut

#########

my %gt=(); # contains the genotype of this individual foreach marker

#################
# Methode new() #
#################

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
	my $ind = bless {
		'name'    => undef,
		'species'      => undef,
		'gt_mrk'	=> undef,
		'genotypes' => [],
		%attrs
	};
	return $ind;
}

=head2 genotypes()
 Title    : genotypes()
 Usage    : my @genotypes= $ind->genotypes() or $ind->genotypes(\@genotypes);
 Function : return all the genotypes for that individual
 Returns  : A list of ProBioDiv:Genotype;
 Args     : a list of ProBioDiv genotypes or nothing

=cut

sub genotypes() {
	my $self=shift;
	if (scalar (@_)) {
		$self->{'genotypes'}= \@_;
	}
	return @{$self->{'genotypes'}}
}

=head2 add_genotype()

 Title    : add_genotype
 Usage    : $ind->add_genotype($gt)
 Function : add a new genotype for that individual
 Returns  :nothing
 Args     : a ProBioDiv::Genotype

=cut

sub add_genotype() {
	my $self=shift;
	if (scalar (@_)) {
		my $gt =shift;
		push @{$self->{'genotypes'}}, $gt;
		$self->{'gt_mrk'}{$gt->marker()}=$gt;
	}
}


=head2 get_genotype()
 Title    : get_genotype(marker=>$mrk)
 Usage    : my $gt = $ind->get_genotype(marker=>$mrk);
 Function : return the genotype of that individual for a marker
 Returns  : a ProBioDiv::Genotype
 Args     : a ProBioDiv::Marker

=cut

sub get_genotype() {
	my $self=shift;
	my %args=(
		marker=> undef,
		@_
	);
	return $self->{'gt_mrk'}{$args{'marker'}};
}

=head2 species()
 Title    : species()
 Usage    : my @genotypes= $ind->species() or $ind->species($sp);
 Function : returns the species of that individual
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

=head2 name()
 Title    : name()
 Usage    : my @genotypes= $ind->name() or $ind->name($name);
 Function : returns the name of that individual
 Returns  : a string
 Args     : a string or nothing

=cut

sub name() {
	my $self=shift;
	if (scalar (@_)) {
		$self->{'name'}= shift;
	}
	return $self->{'name'}
}

1;
