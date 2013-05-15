use strict;use warnings;

package FuckDiabetes::Brag::Comment;
use Moose;
use namespace::autoclean;

extends 'FuckDiabetes::Data::Brag::Metadata';

has 'comment' => (
  is => 'rw',
  isa => 'Str',
);

sub to_string {
  my ($self) = @_;

  return $self->comment;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;