package TwoFAuth::BotHandler;
use Mojo::UserAgent;
use Router::Simple;
use feature 'say';

sub command_start {
  say 'called start';
  my $self = shift;
  my $command = $self->{'current_command'};
  my $message = $self->{'current_message'};
  my @args = @{$self->{'current_args'}}; # perl dark magic

  my $bot = $self->{'bot'};
  my $mojo_ctx = $self->{'mojo_ctx'};
  my $target = $message->{'from'}->{'id'};

  my $provider_code = shift @args;

  if(!$provider_code){
    my $text = 'Welcome to TwoFAuth. In order to use this bot,'
    . ' U\'ll need get here from an authorization link.';

    return $bot->send_message(
      $target, $text
    );

  }

  
  return 'do something with db!';

  my $text = 'Authorizing you on **%PROVIDER%**!'
   . "\n"
   . "Please provide the following code to **%PROVIDER%**"
   . "\n"
   . "\n"
   . "`131-212-333`";
   ;

  return $bot->send_message(
    $target, $text
  );
}

sub command_default {
  say 'DEFAULT!';

  my $self = shift;
  my $command = $self->{'current_command'};
  my $message = $self->{'current_message'};
  my @args = @{$self->{'current_args'}}; # perl dark magic

  my $bot = $self->{'bot'};
  my $mojo_ctx = $self->{'mojo_ctx'};
  my $target = $message->{'from'}->{'id'};

  # check bot state before rejecting

  if(substr($command, 0, 1) eq '/'){
    my $text = "No conozco el comando `".$command."`";

    return $bot->send_message(
      $target, $text
    );
  }

}

sub new {
  my ($class, %args) = @_;
  return bless \%args, $class;
}

sub setup_router {
  my $self = shift;

  my $router = Router::Simple->new();
  
  $router->connect('/start', {
    action => sub {
      return command_start $self;
    }
  });

  $self->{'router'} = $router;

  return $self;
}

sub match {
  my $self = shift;
 
  my $message_json = shift;
  
  my $message_text = $message_json->{'text'};

  my @message_args = split(/ /, $message_text);

  my $command = shift @message_args;

  $self->{'current_message'} = $message_json;
  $self->{'current_command'} = $command;
  $self->{'current_args'} = \@message_args;

  say(">>>>>>> ", $command);

  $r = $self->{'router'}->match($command);
  
  if(!$r){
    return bless {
      action => sub {
        say 'matched default';
        return command_default $self;
      }
    }
  }

  return $r;
}



1;