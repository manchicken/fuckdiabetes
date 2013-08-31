use strict;use warnings;

package FuckDiabetes::Brag::Metadata;
use Moose;
use namespace::autoclean;

has 'typename' => (
  is => 'rw',
  isa => 'Str',
);

# has

no Moose;
__PACKAGE__->meta->make_immutable;
1;