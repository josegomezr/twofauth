package TwoFAuth::BotHandler;
use Router::Simple;
use feature 'say';
use Mojo::UserAgent;

use Class::Accessor::Lite 0.05 (
    new => 1,
    ro => [qw(routes directory_slash)],
);

sub send_message {

  my $target = shift;
  my $text = shift;
  my $extra_args = shift;

  if(!defined($extra_args) or !extra_args){
    $extra_args = {};
  }

  my $ua  = Mojo::UserAgent->new;
  my $token = "bot710352158:AAEsnb0n96a8xIIFWfJyPomkmYErjc45iQo";
  my $url = 'https://api.telegram.org/'. $token .'/sendMessage';

  my $form_data = {
    text => $text,
    parse_mode => 'markdown',
    chat_id => $target,
  };

  for my $key ( keys %$extra_args ) {
    $form_data->{$key} = $extra_args->{$key};
  }

  say $ua->post($url => form => $form_data)->result->body;
}

sub fn {
  my $message = shift;

  my @pieces = split(/ /, $message->{'text'});
  shift @pieces; # command
  my $provider_code = shift @pieces;

  if(!$provider_code){
    my $text = 'Welcome to TwoFAuth. In order to use this bot,'
    . ' U\'ll need get here from an authorization link.';
    send_message $message->{'from'}->{'id'}, $text;  
    return;
  }

  my $text = 'Authorizing you on **%PROVIDER%**!'
   . "\n"
   . "Please provide the following code to **%PROVIDER%**"
   . "\n"
   . "\n"
   . "`131-212-333`";
   ;

  send_message $message->{'from'}->{'id'}, $text;
  
}

sub fn2 {
  #, {
  #   reply_to_message_id => $message->{'message_id'},
  # }
  say "called fn2";
}

sub default {
  say 'DEFAULT!';
}

sub setup {
  my $self = shift;

  my $router = Router::Simple->new();
  
  $router->connect('/start', {
    action => sub {
      say 'matched';
      return fn @_;
    }
  });

  $self->{'router'} = $router;

  return $self;
}

sub match {
  my $self = shift;
  my $message = shift;
  my @pieces = split(/ /, $message);

  my $command = shift @pieces;

  $r = $self->{'router'}->match($command);
  
  if(!$r){
    return bless {
      action => sub {
        default @_;
      }
    }
  }

  return $r;
}

1;