use strict;use warnings;

package FuckDiabetes::Data::FacebookSession;
use Mongoose::Class;

use MongoDB::OID;

use namespace::autoclean;

with 'Mongoose::Document' => {
	-collection_name => 'fb_session',
	-pk => [qw/ access_token /],
};

has 'access_token' => (
	is => 'rw',
	# isa => 'Str',
	# required => 1,
);

has 'name' => (
	is => 'rw',
	# isa => 'Str',
);

has 'fb_data' => (
	is => 'rw',
	isa => 'HashRef',
);

has 'date' => (
	is=>'rw',
	isa=>'DateTime',
	traits=>['Raw'],
	default=>sub{ DateTime->now }
);

belongs_to 'user' => 'FuckDiabetes::Data::User';

sub find_by_session_id {
	my ($self, $_id) = @_;

	if (!defined($_id) || !length($_id)) {
		return undef;
	}

	return $self->find_one({_id=>MongoDB::OID->new(value=>$_id)});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;