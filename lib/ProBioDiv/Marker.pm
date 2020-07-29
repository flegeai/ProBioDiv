package ProBioDiv::Marker;


$VERSION = "v0.0.1";
=head1 Name

ProBioDiv::Marker;

=head1 Description

  This class describes a marker with its name, and chromosomal position

=head1 synopsis

use ProBioDiv::Marker;

# cree un marker
my $marker = new ProBioDiv::Marker(name=> $marker, chromosome => $chr, pos=>$pos);

=cut

#########


#################
# Methode new() #
#################

=head2 new()

 Title    : new()
 Usage    : my $marker = new ProBioDiv::Marker;
 Function : This function creates a Marker object
 Returns  : A ProBioDiv;;Marker
 Args     : valued arguments

=cut


sub new() {
	## Variables
	my ( $class, %attrs ) = @_;

	## Object's attributes
	my $marker = bless {
		'name'    => undef,
		'chromosome' => undef,
		'position'      => undef,
		%attrs
	};
	return $marker;
}


=head2 name()

 Title    : name()
 Usage    : $marker->name("foobar") or $name =  $marker->name;
 Function :  set and get the name of the marker
 Returns  : a string
 Args     : a string

=cut

sub name {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'name'}= shift;
	}
	return $self->{'name'};
}


=head2 chromosome()

 Title    : chromosome()
 Usage    : $marker->chromosome("A01") or $chr = $marker->chromosome;
 Function :  set and get the chromosome of the marker
 Returns  : a string
 Args     : a string

=cut

sub chromosome {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'chromosome'}= shift;
	}
	return $self->{'chromosome'};
}

=head2 position()

 Title    : position()
 Usage    : $marker->position("12345") or $position = $marker->position;
 Function :  set and get the position of the marker
 Returns  : an integer
 Args     : an integer

=cut

sub position {
	my $self=shift;
	if (scalar(@_)) {
		$self->{'position'}= shift;
	}
	return $self->{'position'};
}

=head2 status()

 Title    : status()
 Usage    : $marker->status("HET") or $status = $marker->status;
 Function :  set and get the status of the marker (BAD, HET, NP, P)
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
