use strict;use warnings;

package FuckDiabetes::Data::User;
use Mongoose::Class;
use namespace::autoclean;

use FuckDiabetes::Data::Brag;

=pod

=head1 NAME

FuckDiabetes::Data::User - A data model for Users within the FuckDiabetes application.

=head1 SYNOPSIS

 use FuckDiabetes::Data::User;

=cut

with 'Mongoose::Document' => {
	-collection_name => 'fd_users',
};

has 'access_token' => (
	is=>'rw',
	isa=>'Str',
);

has 'name' => (
	is => 'rw',
	isa => 'Str',
);

has 'date' => (
	is=>'rw',
	isa=>'DateTime',
	traits=>['Raw'],
	default=>sub{ DateTime->now },
);

has_many 'brags' => (
  is=>'rw',
  isa=>q{FuckDiabetes::Data::Brag},
);

sub oid {
	my ($self) = @_;

	return $self->_id->{value};
}

sub find_by_name {
	my ($pkg, $name) = @_;

	return $pkg->find_one({name=>$name});
}

sub find_by_access_token {
	my ($pkg, $access_token) = @_;

	return $pkg->find_one({access_token=>$access_token});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
