use strict;
use warnings;

package FuckDiabetes::Model::Brag;
use Mongoose::Class;
use namespace::autoclean;

use MongoDB::OID;

use DateTime;
use Data::Dumper;

use FuckDiabetes::Model::Locale;
use FuckDiabetes::Model::User;

with 'Mongoose::Document' => {
  -collection_name => 'brags',
  -pk              => [qw/ _id /],
};

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

has 'brag_schema' => (
  is      => 'ro',
  isa     => 'Str',
  default => 'Brag',
);

has 'author' => (
  is  => 'rw',
  isa => 'Str',
);

has 'author_oid' => (
  is  => 'rw',
  isa => 'Str',
);

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

sub apply_schema {
  my ($self) = @_;

  my $className = "FuckDiabetes::Data";

  if ( !defined( $self->brag_schema ) || length( $self->brag_schema ) > 0 ) {
    $className .= "::Brag";
  } else {
    $className .= "::" . $self->brag_schemapkg;
  }

  print STDERR "Loading brag with classname '$className'\n";
  print STDERR Dumper( $self->_id->value );
  eval("use $className;");
  my $instance = $className->find_one( $self->_id->value );

  # print STDERR Dumper(ref $instance);

  return $instance;
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

no Moose;
__PACKAGE__->meta->make_immutable;

1;
