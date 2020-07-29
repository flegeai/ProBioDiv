package ProBioDiv::Genotype;
use strict;
use warnings;

my $VERSION = "v0.0.1";
=head1 Name

ProBioDiv::Genotype;

=head1 Description

  This class describes a genotype with its value for a particular indivividual

=head1 synopsis

use ProBioDiv::Genotype;

# cree un genotype
my $genotype = new ProBioDiv::Genotype(marker=>$marker, individual=> $ind, value=> $value);

=cut

#########


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
	my $gt = bless {
		'marker'    => undef,
		'individual' => undef,
		'value'      => undef,
		%attrs
	};
	return $gt;
}

=head2 marker()
 Title    : marker()
 Usage    : my $marker $gt->marker() or $gt->marker($marker);
 Function : returns the marker  for that genotype
 Returns  : A ProBioDiv:Marker;
 Args     : a ProBioDiv::Marker or nothing

=cut

sub marker() {
	my $self=shift;
	if (scalar (@_)) {
		$self->{'marker'}=shift;
	}
	return ($self->{'marker'})
}


=head2 individual()
 Title    : individual()
 Usage    : my $marker $gt->individual() or $gt->individual($individual);
 Function : returns the individual  for that genotype
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


=head2 value()
 Title    : value()
 Usage    : my $val=$gt->value() or $gt->value($val);
 Function : returns the value  for that genotype
 Returns  : a string
 Args     : a string or nothing

=cut

sub value() {
	my $self=shift;

	if (scalar (@_)) {
		$self->{'value'}=shift;
	}
	return ($self->{'value'})
}

=head2 status()

 Title    : status()
 Usage    : $gt->status("Nint") or $status = $gt->status;
 Function :  set and get the status of the genotype (Int, NInt, Ninf)
 Returns  : a string
 Args     : a string

=cut

sub status{
	my $self=shift;
	if (scalar(@_)) {
		$self->{'status'}= shift;
	}
	return $self->{'status'};
}
