package TwoFAuth::BotAPI;
use Mojo::UserAgent;
use Router::Simple;
use feature 'say';

sub new {
  my ($class, %args) = @_;
  return bless \%args, $class;
}

sub send_message {
  my $self = shift;
  my $target = shift;
  my $text = shift;
  my %extra_args = @_;

  my $token = $self->{'bot_token'};
  my $ua = Mojo::UserAgent->new;
  my $url = 'https://api.telegram.org/bot'. $token .'/sendMessage';

  if (!exists $extra_args{'parse_mode'}) {
    $extra_args{'parse_mode'} = 'markdown';
  }

  my $form_data = {
    text => $text,
    chat_id => $target,
  };

  for my $key ( keys %extra_args ) {
    $form_data->{$key} = $extra_args{$key};
  }

  return $ua->post($url => form => $form_data)->result->body;
}

1;