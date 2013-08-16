#!/usr/bin/env perl
use Mojo::Base -strict;

use Test::More tests => 3;
use Test::Mojo;

use Data::Dumper;
use lib qw/lib/;

$ENV{FD_TESTING} = 1;

my $t = Test::Mojo->new('FuckDiabetes');
$t->get_ok('http://fuckdiabetes.info/')->status_is(200)->content_like(qr/Fuck Diabetes: Home/i);

# my $html = $t->{tx}->{res}->{content};
# print STDOUT Dumper($html);
