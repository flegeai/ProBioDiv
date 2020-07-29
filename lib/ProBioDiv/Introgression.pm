package ProBioDiv::Introgression;
use strict;
use warnings;

my $VERSION = "v0.0.1";
=head1 Name

ProBioDiv::Introgression;

=head1 Description

  This class describes an introgression

=head1 synopsis

use ProBioDiv::Introgression;

# cree un genotype
my $introgression = new ProBioDiv::Introgression(individual=>$ind, chr=> $chr, start=> $start, end=> $end);

=cut

#########


#################
# Methode new() #
#################

=head2 new()

 Title    : new()
 Usage    : my $gt = new ProBioDiv::Introgression;
 Function : This function creates an introgression object
 Returns  : A ProBioDiv;;Introgression
 Args     : valued arguments

=cut


sub new() {
	## Variables
	my ( $class, %attrs ) = @_;

	## Object's attributes
	my $int = bless {
		'individual' => undef,
		'chr'      => undef,
		'start'	=> undef,
		'end' => undef,
		'nb_inf_mrks' => 0,
		'nb_ninf_mrks' => 0,
		%attrs
	};
	return $int;
}

=head2 end()
 Title    : end()
 Usage    : my $int->end() or $int->end($marker);
 Function : returns the ending marker of this introgression
 Returns  : A ProBioDiv:Marker;
 Args     : a ProBioDiv::Marker or nothing

=cut

sub end() {
	my $self=shift;
	if (scalar (@_)) {
		$self->{'end'}=shift;
	}
	return ($self->{'end'})
}

=head2 start()
 Title    : start()
 Usage    : my $int->start() or $int->start($marker);
 Function : returns the starting marker of this introgression
 Returns  : A ProBioDiv:Marker;
 Args     : a ProBioDiv::Marker or nothing

=cut

sub start() {
	my $self=shift;
	if (scalar (@_)) {
		$self->{'start'}=shift;
	}
	return ($self->{'start'})
}


=head2 individual()
 Title    : individual()
 Usage    : my $ind= $int->individual() or $int->individual($individual);
 Function : returns the individual of that introgression
 Returns  : A ProBioDiv:Individual;
 Args     : a ProBioDiv::Individual or nothing

=cut

sub individual() {
	my $self=shift;

	if (scalar (@_)) {
		$self->{'individual'}=shift;
	}
	return ($self->{'individual'})
}


=head2 chr()
 Title    : chr()
 Usage    : my $chr=$int->chr() or $int->chr($chr);
 Function : returns the chromosome  for this introgression
 Returns  : a string
 Args     : a string or nothing

=cut

sub chr() {
	my $self=shift;

	if (scalar (@_)) {
		$self->{'chr'}=shift;
	}
	return ($self->{'chr'})
}

=head2 nb_inf_mrks()

 Title    : nb_inf_mrks()
 Usage    : my $chr=$int->nb_inf_mrks() or $int->nb_ninf_mrks($chr);
 Function : returns the number of informative markers for this introgression
 Returns  : an integer
 Args     : an integer or nothing

=cut

sub nb_inf_mrks() {
	my $self=shift;

	if (scalar (@_)) {
		$self->{'nb_inf_mrks'}=shift;
	}
	return ($self->{'nb_inf_mrks'})
}

=head2 nb_ninf_mrks()

 Title    : nb_ninf_mrks()
 Usage    : my $chr=$int->nb_ninf_mrks() or $int->nb_ninf_mrks($chr);
 Function : returns the number of informative markers for this introgression
 Returns  : an integer
 Args     : an integer or nothing

=cut

sub nb_ninf_mrks() {
	my $self=shift;

	if (scalar (@_)) {
		$self->{'nb_ninf_mrks'}=shift;
	}
	return ($self->{'nb_ninf_mrks'})
}
