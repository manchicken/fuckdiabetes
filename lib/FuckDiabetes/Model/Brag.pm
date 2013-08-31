=pod

=head1 NAME

FuckDiabetes::Model::Brag - A data model for Brag items within the FuckDiabetes application.

=head1 SYNOPSIS

 use FuckDiabetes::Model::Brag;

=head1 DESCRIPTION

In the FuckDiabetes application, each item is referred to as a E<Brag>. A brag can be either a glucose reading, a general statement, or something else (very TBD). This is the class which holds on to all of it.

The roles of the E<Brag> are key. A role tells you whether the E<Brag> is a glucose reading, or is permitted to have comments.

=head1 METHODS

=over

=cut

use strict;
use warnings;

package FuckDiabetes::Model::Brag;
use Mongoose::Class;
use namespace::autoclean;

use MongoDB::OID;
use Moose::Util qw/apply_all_roles does_role/;

use DateTime;
use Data::Dumper;

use FuckDiabetes::Model::Locale;
use FuckDiabetes::Model::User;

with 'Mongoose::Document' => {
  -collection_name => 'brags',
  -pk              => [qw/ _id /],
};

with 'FuckDiabetes::Model::Role::Comment';

has 'title' => (
  is  => 'rw',
  isa => 'Str',
);

has 'body' => (
  is  => 'rw',
  isa => 'Str',
);

has 'active' => (
  is  => 'rw',
  isa => 'Bool',

  default => 1,
);

has 'timestamp' => (
  is      => 'ro',
  isa     => q{DateTime},
  default => sub { return DateTime->now(); },
);

has 'roles' => (
  is      => 'ro',
  isa     => 'ArrayRef[Str]',
);

has 'author' => (
  is  => 'rw',
  isa => 'Str',
);

has 'author_oid' => (
  is  => 'rw',
  isa => 'Str',
);

=pod

=item author_oid_from_object

Since a E<Brag> is only loosely tied to a E<User> entity, we don't keep a formal reference. We do, however, want to have some way of tying back to a user. This is a convenience method which allows us to set the OID based on the E<User> object.

=cut

sub author_oid_from_object {
  my ( $self, $aobj ) = @_;

  return $self->author_oid( $aobj->_id->{value} )
    unless ( !ref($aobj) || !$aobj->isa(q{FuckDiabetes::Model::User}) );

  return undef;
}

sub oid {
  my ($self) = @_;

  return undef unless ( defined $self->_id );

  return $self->_id->{value};
}

sub to_string {
  my ($self) = @_;

  return $self->title . ': ' . $self->body;
}

=pod

=item timestamp_formatted()

This method returns a timestamp formatted for the current locale.

=cut

sub timestamp_formatted {
  my ($self) = @_;

  if ( ref( $self->timestamp ) ) {
    my $dtLocale =
      DateTime::Locale->load( FuckDiabetes::Model::Locale->new->locale() );
    $self->timestamp->set_time_zone(
      FuckDiabetes::Model::Locale->new->timezone() );
    return $self->timestamp->format_cldr(
      $dtLocale->datetime_format_medium() );
  }

  return "N/A";
}

=pod

=item materialize()

This method applies the roles to the instance.

=cut

sub materialize {
  my ($self) = @_;
  
  return if (!defined $self->roles || !ref $self->roles);
  
  my @roles_to_apply = ();
  
  for my $role (@{$self->roles}) {
    if (!does_role($self, $role)) {
      push @roles_to_apply, $role;
    }
  }
  
  apply_all_roles($self, @roles_to_apply);
  
  return $self;
}

sub find_by_id {
  my ( $pkg, $oid ) = @_;

  if ( !defined($oid) || !length($oid) ) {
    return undef;
  }

  return $pkg->find_one( { _id => MongoDB::OID->new( value => $oid ) } );
}

sub find_all_by_author {
  my ( $pkg, $author ) = @_;

  return undef unless defined $author;

  return $pkg->find(
    { author => $author },
    { sort_by => { timestamp => 1 },
      skip    => 0,
    }
  );
}

=pod

=back

=cut

no Moose;
__PACKAGE__->meta->make_immutable;

1;
