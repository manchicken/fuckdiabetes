use strict;
use warnings;

use Test::More tests => 1;
use Test::Mojo;
use DateTime;
use Data::Dumper;
use lib qw/lib/;

$ENV{FD_TESTING} = 1;

sub BEGIN {
  require FuckDiabetes::TestSupport;
  use_ok(q{FuckDiabetes::Model::Brag});
}

sub END {
  my $collection = FuckDiabetes::Model::Brag->collection();
  $collection->drop();
  print "Cleaned up!\n";
}

my $known_timestamp = DateTime->new(
  year      => '2008',
  month     => '01',
  day       => '15',
  hour      => '17',
  minute    => '48',
  second    => '00',
  time_zone => 'America/Chicago',
);
