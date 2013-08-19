use strict;use warnings;

use Test::More tests => 11;
use Test::Mojo;
use DateTime;
use Data::Dumper;
use lib qw/lib/;

$ENV{FD_TESTING} = 1;

sub BEGIN {
  require FuckDiabetes::TestSupport;
  use_ok(q{FuckDiabetes::Data::Brag});
}

sub END {
  my $collection = FuckDiabetes::Data::Brag->collection();
  $collection->remove();
  my $ucollection = FuckDiabetes::Data::User->collection();
  $ucollection->remove();
  print "Cleaned up!\n";
}

my $user = FuckDiabetes::Data::User->new(access_token=>'abc123', name=>'somebody');
isa_ok($user, q{FuckDiabetes::Data::User}, 'Verify we got a proper instance...');
is($user->access_token, 'abc123', 'Verify we got the access token we put in...');
is($user->name, 'somebody', 'Verify we got the name we put in...');
ok($user->save(), 'Verify we can save...');

my $known_timestamp = DateTime->new(
  year => '2008',
  month => '01',
  day => '15',
  hour => '17',
  minute => '48',
  second => '00',
  time_zone=>'America/Chicago',
);

my $one = FuckDiabetes::Data::Brag->new(
  title => 'brag 1',
  body => 'This is brag 1',
  author => $user,
  timestamp => $known_timestamp,
);
isa_ok($one, q{FuckDiabetes::Data::Brag}, 'Verify we got a proper instance...');
ok($one->save(), 'Verify we have saved...');

my $one_loaded = FuckDiabetes::Data::Brag->find_by_id($one->oid);
isa_ok($one_loaded, q{FuckDiabetes::Data::Brag}, 'Verify we got an instance...');
is($one_loaded->title, 'brag 1', 'Verify we loaded what we wanted...');
is($one_loaded->timestamp_formatted, 'Jan 15, 2008 5:48:00 PM', 'Verify that the formatted timestamp works...');
is($one_loaded->author->oid, $user->oid, 'Verify that the OID matches...');

# Now let's try loading by author now :)
# my $byauthor_obj = FuckDiabetes::Data::Brag->find_all_by_author($user);
# isa_ok($byauthor_obj, q{Mongoose::Cursor}, 'Verify that we have a cursor...');
# my $obj1 = $byauthor_obj->next();
# print '!!'.Dumper([$byauthor_obj->all])."\n";
# isa_ok($obj1, q{FuckDiabetes::Data::Brag}, 'Verify that we got an item...');