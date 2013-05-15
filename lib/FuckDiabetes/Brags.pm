package FuckDiabetes::Brags;
use Mojo::Base 'Mojolicious::Controller';

# Models
use aliased 'FuckDiabetes::Data::Brag';
use aliased 'FuckDiabetes::Data::FacebookSession';

# This action will render a template
sub create {
  my ($self) = @_;

  $self->render();
}

sub save {
	my ($self) = @_;

	my $type = $self->param('type') || undef;

	# If we have a type, this is where we should send it to that type's specific save routine

	my $title = $self->param('title') || do {
		$self->flash(message=>'No title supplied');
		$self->render(controller=>'brags',action=>'create',type=>$type);
		return;
	};
	my $body = $self->param('body') || do {
		$self->flash(message=>'No body supplied');
		$self->render(controller=>'brags',action=>'create',type=>$type);
		return;
	};

  my $fbs = FacebookSession->find_by_session_id($self->session('_id'));

	my $newBrag = Brag->new(title=>$title,body=>$body,author=>$fbs->user);
	$newBrag->save();

	$self->redirect_to('/');
}

1;