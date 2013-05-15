package FuckDiabetes::Home;
use Mojo::Base 'Mojolicious::Controller';

# Models
use aliased 'FuckDiabetes::Data::Brag';
use aliased 'FuckDiabetes::Data::FacebookSession';

# This action will render a template
sub welcome {
  my $self = shift;

  my $fbs = FacebookSession->find_by_session_id($self->session('_id'));

  my $can_post = ($fbs != undef);

	my $brags = Brag->find(
		{
			active => 1,
		},
		{
			sort_by => {timestamp=>1},
			limit => 10,
			skip => 0,
		},
	);

  $self->render(
  	brags=>$brags,
  	can_post=>$can_post,
  	fbs=>$fbs);
}

sub config {
	my ($self) = @_;

	# my $model = FuckDiabetes::Data::FuckConfig->find_one();

	$self->render(
		# configdata => $self->app->config,
	);
}

1;