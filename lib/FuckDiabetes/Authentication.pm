package FuckDiabetes::Authentication;
use Mojo::Base 'Mojolicious::Controller';

use Facebook::Graph;
use aliased 'FuckDiabetes::Data::FacebookSession' => 'FacebookSession';
use aliased 'FuckDiabetes::Data::User' => 'User';

sub login {
	my ($self) = @_;

	my $goto = $self->param('goto') || 'home';
	if (defined($goto) && length($goto) > 0) {
		$self->session('goto'=>$goto);
	}

	my $fb = Facebook::Graph->new(
    app_id          => $self->app->config->{appid},
    secret          => $self->app->config->{appsecret},
    postback        => $self->app->config->{postback},
	);
	my $uri = $fb->authorize->extend_permissions(qw(offline_access publish_stream))->uri_as_string();

	$self->redirect_to($uri);
}

sub postback {
	my ($self) = @_;

	my $fb = Facebook::Graph->new(
    app_id          => $self->app->config->{appid},
    secret          => $self->app->config->{appsecret},
    postback        => $self->app->config->{postback},
	);
	my $code = $self->param('code');
	my $access_token = $fb->request_access_token($code);
	my $me = $fb->fetch('me');

	my $fb_session = FacebookSession->find_one({access_token => $access_token->token()}) ||
		FacebookSession->new(access_token=>$access_token->token());

	$fb_session->name($me->{'username'});
	$fb_session->fb_data($me);

	# Duplicate prevention...
	FacebookSession->collection->remove({
		name => $me->{'username'},
		access_token => {'$ne' => $access_token->token() },
	});

	$fb_session->save();

	if (!$fb_session->user) {
		my $user = User->new(name => $fb_session->name);
		$user->fb_session($fb_session);
		$user->save();
		$fb_session->user($user);
		$fb_session->save();
	}

	$self->session(_id=>$fb_session->_id->to_string());

	my $goto = $self->session('goto') || 'home';
	if (defined($goto) && length($goto) > 0) {
		$self->redirect_to($goto);
	}

	$self->render(
		mydata => $fb_session,
		session_id => $self->session('_id'),
	);
}

sub auth_header {
	my ($self) = @_;

	# $self->render();
}

1;