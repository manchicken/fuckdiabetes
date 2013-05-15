use strict;use warnings;

package FuckDiabetes::Brag::Comment;
use Mongoose::Class;
use namespace::autoclean;

with 'Mongoose::Document' => {
	-collection_name => 'comments'
};

has 'title' => (
	is => 'rw',
	isa => 'Str',
);

# has

no Moose;
__PACKAGE__->meta->make_immutable;
1;