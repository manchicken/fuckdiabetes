use strict;
use warnings;

package FuckDiabetes::Model::Locale;
use Mongoose::Class;
use namespace::autoclean;

has 'locale' => (
  is      => 'rw',
  isa     => 'Str',
  default => 'en_US',
);

has 'timezone' => (
  is      => 'rw',
  isa     => 'Str',
  default => 'America/Chicago',
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
