use strict;use warnings;

use Test::More tests => 27;
use Test::Mojo;
use lib qw/lib/;

$ENV{FD_TESTING} = 1;

sub BEGIN {
  require FuckDiabetes::TestSupport;
  use_ok(q{FuckDiabetes::Data::User});
}

sub END {
  my $collection = FuckDiabetes::Data::User->collection();
  $collection->remove();
  print "Cleaned up!\n";
}

my $t1 = FuckDiabetes::Data::User->new(access_token=>'abc123', name=>'somebody');
isa_ok($t1, q{FuckDiabetes::Data::User}, 'Verify we got a proper instance...');
is($t1->access_token, 'abc123', 'Verify we got the access token we put in...');
is($t1->name, 'somebody', 'Verify we got the name we put in...');
ok($t1->save(), 'Verify we can save...');

my $t1_lookup_by_name = FuckDiabetes::Data::User->find_by_name('somebody');
isa_ok($t1_lookup_by_name, q{FuckDiabetes::Data::User}, 'Verify we have a proper instance...');
is($t1_lookup_by_name->access_token, 'abc123', 'Verify that we have the token we put in...');
is($t1_lookup_by_name->name, 'somebody', 'Verify that we have the name we put in...');

my $t1_lookup_by_access_token = FuckDiabetes::Data::User->find_by_access_token('abc123');
isa_ok($t1_lookup_by_access_token, q{FuckDiabetes::Data::User}, 'Verify we have a proper instance...');
is($t1_lookup_by_access_token->access_token, 'abc123', 'Verify that we have the token we put in...');
is($t1_lookup_by_access_token->name, 'somebody', 'Verify that we have the name we put in...');

$t1->name('somebodyelse');
is($t1->name, 'somebodyelse', 'Verify the name changed...');
ok($t1->save(), 'Verify we can save...');

$t1_lookup_by_name = FuckDiabetes::Data::User->find_by_name('somebodyelse');
isa_ok($t1_lookup_by_name, q{FuckDiabetes::Data::User}, 'Verify we have a proper instance...');
is($t1_lookup_by_name->access_token, 'abc123', 'Verify that we have the token we put in...');
is($t1_lookup_by_name->name, 'somebodyelse', 'Verify that we have the name we put in...');

$t1_lookup_by_access_token = FuckDiabetes::Data::User->find_by_access_token('abc123');
isa_ok($t1_lookup_by_access_token, q{FuckDiabetes::Data::User}, 'Verify we have a proper instance...');
is($t1_lookup_by_access_token->access_token, 'abc123', 'Verify that we have the token we put in...');
is($t1_lookup_by_access_token->name, 'somebodyelse', 'Verify that we have the name we put in...');

$t1->access_token('xyz987');
is($t1->access_token, 'xyz987', 'Verify the access_token changed...');
ok($t1->save(), 'Verify we can save...');

$t1_lookup_by_name = FuckDiabetes::Data::User->find_by_name('somebodyelse');
isa_ok($t1_lookup_by_name, q{FuckDiabetes::Data::User}, 'Verify we have a proper instance...');
is($t1_lookup_by_name->access_token, 'xyz987', 'Verify that we have the token we put in...');
is($t1_lookup_by_name->name, 'somebodyelse', 'Verify that we have the name we put in...');

$t1_lookup_by_access_token = FuckDiabetes::Data::User->find_by_access_token('xyz987');
isa_ok($t1_lookup_by_access_token, q{FuckDiabetes::Data::User}, 'Verify we have a proper instance...');
is($t1_lookup_by_access_token->access_token, 'xyz987', 'Verify that we have the token we put in...');
is($t1_lookup_by_access_token->name, 'somebodyelse', 'Verify that we have the name we put in...');
