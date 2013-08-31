use strict;use warnings;

package FuckDiabetes::Brag::BloodGlucose;
use Moose::Role;
use namespace::autoclean;

has 'reading' => (
  is => 'rw',
  isa => 'Num',
);

has 'units' => (
  is => 'rw',
  isa => enum(['mg/dL', 'mmol']),
);

# Before meal, after meal, etc...
has 'event' => (
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