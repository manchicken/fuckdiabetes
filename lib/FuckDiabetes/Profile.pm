package FuckDiabetes::Profile;
use Mojo::Base 'Mojolicious::Controller';

# Models
use FuckDiabetes::Data::User;

# This action will render a template
sub view {
  my ($self, $id) = @_;

  my $model = FuckDiabetes::Data::User->find_by_id($id);

  $self->render(
  	model => $model,
  );
}

sub edit {
	my ($self, $id) = @_;

  my $model = FuckDiabetes::Data::User->find_by_id($id);

  $self->render(
  	model => $model,
  );
}

1;