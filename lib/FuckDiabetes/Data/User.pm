use strict;use warnings;

package FuckDiabetes::Data::User;
use Mongoose::Class;
use namespace::autoclean;

with 'Mongoose::Document' => {
	-collection_name => 'fd_users',
	-pk => [qw/ name /],
};

has 'name' => (
	is => 'rw',
	isa => 'Str',
);

has 'date' => (
	is=>'rw',
	isa=>'DateTime',
	traits=>['Raw'],
	default=>sub{ DateTime->now }
);

# has_one 'fb_session' => 'FuckDiabetes::Data::FacebookSession';
# has_many 'brags' => 'FuckDiabetes::Data::Brag';

sub find_by_name {
	my ($self, $name) = @_;

	return $self->find_one({name=>$name});
}

sub find_by_id {
	my ($self, $_id) = @_;

	$_id ||= $self->_id;

	return $self->find_one({id=>$_id});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
