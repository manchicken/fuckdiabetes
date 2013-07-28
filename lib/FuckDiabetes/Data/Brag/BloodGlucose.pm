use strict;use warnings;

package FuckDiabetes::Brag::BloodGlucose;
use Moose;
use namespace::autoclean;

extends 'FuckDiabetes::Data::Brag::Metadata';

has 'reading' => (
  is => 'rw',
  isa => 'Str',
);

sub to_string {
  my ($self) = @_;

  return "Glucose reading: ".$self->reading;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;