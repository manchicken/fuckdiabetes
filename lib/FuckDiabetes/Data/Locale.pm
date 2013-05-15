use strict;use warnings;

package FuckDiabetes::Data::Locale;
use Mongoose::Class;
use namespace::autoclean;

has 'locale' => (
	is => 'rw',
	isa => 'Str',
	default => 'en_US',
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;