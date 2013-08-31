use strict;use warnings;

package FuckDiabetes::Model::Role::Comment;
use Moose::Role;

use DateTime;
use FuckDiabetes::Model::Locale;

has 'comments' => (
  is => 'rw',
  isa => 'ArrayRef[HashRef[Any]]',
);

has 'allows_comments' => (
  is => 'rw',
  isa => 'Bool',
);

sub add_comment {
  my ($self, $new_comment) = @_;
  
  if (ref($new_comment) eq 'HASH') {
    push @{$self->comments}, $new_comment;
    return $self->comments;
  }
  
  push @{$self->comments}, {
    comment => $new_comment,
    author => 'Anonymous',
    timestamp => DateTime->now(time_stamp=>FuckDiabetes::Model::Locale->timezone),
  };
}

sub to_string {
  my ($self) = @_;

  return $self->comment;
}

1;