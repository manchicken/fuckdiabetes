use strict;
use warnings;

=pod

=head1 NAME

FuckDiabetes::TestSupport

=head1 SYNOPSIS

require FuckDiabetes::TestSupport;

=head1 DESCRIPTION

Since we're doing a bunch of stuff with Mojolicious and the JSONConfig plugin,
as well as supporting two mongo instances (one for testing and one for live),
this is for my own convenience. It allows us to use the config file in Mojo to
load the test.

=cut

use Test::Mojo;
use Mongoose;

my $_t = Test::Mojo->new('FuckDiabetes');
Mongoose->db($_t->app->config->{test_mongo_instance});

1;