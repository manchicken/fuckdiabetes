package FuckDiabetes;
use Mojo::Base 'Mojolicious';

use Mongoose;
use aliased 'FuckDiabetes::Model::FacebookSession' => 'FacebookSession';

# This method will run once at server start
sub startup {
  my ($self) = @_;
	
	$self->plugin('JSONConfig');

  if (exists($ENV{FD_TESTING})) {
    Mongoose->db($self->app->config->{test_mongo_instance});
  } else {
    Mongoose->db($self->app->config->{mongo_instance});
  }

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
	$self->plugin('DefaultHelpers');
  $self->plugin('TagHelpers');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('home#welcome');
  $r->get('/home')->to('home#welcome');
  $r->get('/config')->to('home#config');
  $r->get('/login')->to('authentication#login');
  $r->get('/postback')->to('authentication#postback');
  $r->get('/profile/:action/:id')->to(controller=>'profile',action=>'index',id=>undef);

  $r->get('/brags')->to('home#welcome');
  $r->get('/brags/create')->to(controller=>'brags', action=>'create', type=>undef);
  $r->get('/brags/:type/create')->to(controller=>'brags', action=>'create', type=>undef);
  $r->post('/brags/save')->to(controller=>'brags', action=>'save');
}

1;
