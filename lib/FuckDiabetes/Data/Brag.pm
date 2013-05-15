use strict;use warnings;

package FuckDiabetes::Data::Brag;
use Mongoose::Class;
use namespace::autoclean;

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

has 'metadata' => (
	is => 'rw',
	isa => 'FuckDiabetes::Data::Metadata'
);

belongs_to 'author' => (
	is => 'rw',
	isa => 'FuckDiabetes::Data::User',
);

sub to_string {
	my ($self) = @_;

	return $self->title . ': ' . $self->body;
}

sub timestamp_formatted {
	my ($self) = @_;

	if (ref($self->timestamp)) {
		my $dtLocale = DateTime::Locale->load(Locale->new->locale());
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
		$className .= "::" . $self->brag_schema;
	}

	print STDERR "Loading brag with classname '$className'\n";
	print STDERR Dumper($self->_id->value);
	eval("use $className;");
	my $instance = $className->find_one( $self->_id->value );
	# print STDERR Dumper(ref $instance);

	return $instance;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
