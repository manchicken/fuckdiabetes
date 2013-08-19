use strict;use warnings;

package FuckDiabetes::Data::Brag;
use Mongoose::Class;
use namespace::autoclean;

use MongoDB::OID;

use DateTime;
use Data::Dumper;

use aliased 'FuckDiabetes::Data::Locale';
use aliased 'FuckDiabetes::Data::User';

with 'Mongoose::Document' => {
	-collection_name => 'brags',
};

has 'title' => (
	is => 'rw',
	isa => 'Str',
);

has 'body' => (
	is => 'rw',
	isa => 'Str',
);

has 'active' => (
	is => 'rw',
	isa => 'Bool',
	default => 1,
);

has 'timestamp' => (
	is => 'ro',
	isa => 'DateTime',
	default => sub { return DateTime->now(); },
);

has 'brag_schema' => (
	is => 'ro',
	isa => 'Str',
	default => 'Brag'
);

belongs_to 'author' => (
	is => 'rw',
	isa => 'FuckDiabetes::Data::User',
);

sub oid {
	my ($self) = @_;

	return $self->_id->{value};
}

sub to_string {
	my ($self) = @_;

	return $self->title . ': ' . $self->body;
}

sub timestamp_formatted {
	my ($self) = @_;

	if (ref($self->timestamp)) {
		my $dtLocale = DateTime::Locale->load(Locale->new->locale());
		$self->timestamp->set_time_zone(Locale->new->timezone());
		return $self->timestamp->format_cldr($dtLocale->datetime_format_medium());
	}

	return "N/A";
}

sub apply_schema {
	my ($self) = @_;

	my $className = "FuckDiabetes::Data";

	if (!defined($self->brag_schema) || length($self->brag_schema) > 0) {
		$className .= "::Brag";
	} else {
		$className .= "::" . $self->brag_schemapkg	}

	print STDERR "Loading brag with classname '$className'\n";
	print STDERR Dumper($self->_id->value);
	eval("use $className;");
	my $instance = $className->find_one( $self->_id->value );
	# print STDERR Dumper(ref $instance);

	return $instance;
}

sub find_by_id {
	my ($pkg, $oid) = @_;

	if (!defined($oid) || !length($oid)) {
		return undef;
	}

	return $pkg->find_one({_id=>MongoDB::OID->new(value=>$oid)});
}

sub find_all_by_author {
	my ($pkg, $author) = @_;

	my $aid = undef;

	return undef unless defined $author;

	if (ref($author) && $author->isa(q{FuckDiabetes::Data::User})) {
		$aid = $author->oid;
	} else {
		$aid = $author;
	}

	return $pkg->find(
		{author=>$aid},
		{
			sort_by => {timestamp=>1},
			skip => 0,
		}
	);
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
