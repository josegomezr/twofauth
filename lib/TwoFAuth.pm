package TwoFAuth;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $file = $ENV{TWO_F_AUTH_CONF} || 'two_f_auth.conf';
  my $config = $self->plugin(Config => {file => $file});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->any('/bot-webhook')->to('BotWebhook#callback');
}

1;
