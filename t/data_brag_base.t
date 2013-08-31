use strict;
use warnings;

use Test::More tests => 16;
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
  my $ucollection = FuckDiabetes::Model::User->collection();
  $ucollection->drop();
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

my $one = FuckDiabetes::Model::Brag->new(
  title      => 'brag 1',
  body       => 'This is brag 1',
  timestamp  => $known_timestamp,
  author     => 'Xabc123',
  author_oid => 'abc123abc123',
);

isa_ok( $one, q{FuckDiabetes::Model::Brag},
  'Verify we got a proper instance...' );
ok( $one->save(), 'Verify we have saved...' );

my $one_loaded = FuckDiabetes::Model::Brag->find_by_id( $one->oid );
isa_ok( $one_loaded, q{FuckDiabetes::Model::Brag},
  'Verify we got an instance...' );
is( $one_loaded->title, 'brag 1', 'Verify we loaded what we wanted...' );
is(
  $one_loaded->timestamp_formatted,
  'Jan 15, 2008 5:48:00 PM',
  'Verify that the formatted timestamp works...'
);
is( $one_loaded->author, 'Xabc123',
  'Verify the author name came through...' );
is( $one_loaded->author_oid, 'abc123abc123',
  'Verify the author_oid came through...' );

my $byauthor_obj = FuckDiabetes::Model::Brag->find_all_by_author('Xabc123');

# print "I have ".$byauthor_obj->count." items.\n";
isa_ok( $byauthor_obj, q{Mongoose::Cursor},
  'Verify that we have a cursor...' );

# print '!!'.Dumper([$byauthor_obj])."\n";
my $obj1 = $byauthor_obj->next();
isa_ok( $obj1, q{FuckDiabetes::Model::Brag},
  'Verify that we got an item...' );
is( $obj1->title, 'brag 1', 'Verify that we got brag 1...' );

my $t1 = FuckDiabetes::Model::User->new(
  access_token => 'Xabc123',
  name         => 'Xsomebody'
);
isa_ok( $t1, q{FuckDiabetes::Model::User},
  'Verify we got a proper instance...' );
is( $t1->access_token, 'Xabc123',
  'Verify we got the access token we put in...' );
is( $t1->name, 'Xsomebody', 'Verify we got the name we put in...' );
ok( $t1->save(), 'Verify we can save...' );

$one_loaded->author_oid_from_object($t1);
is( $one_loaded->author_oid, $t1->oid(),
  'Verify we properly set the author_oid from an object...' );
