package TwoFAuth::Controller::BotWebhook;
use feature 'say';
use Mojo::Base 'Mojolicious::Controller';

use TwoFAuth::BotHandler;

# This action will render a template
sub callback {
  my $self = shift;

  our $payload = undef;
  my $content_type = $self->req->headers->content_type;
  
  if (defined($content_type) && $content_type =~ /\/json/i) {
    $payload = $self->req->json
  }else{
    $payload = $self->req->params->to_hash;
  }

  if(!$payload){
    return $self->render(json => {
      error => 'bad payload'
    })
  }

  my $message = {};

  if (exists $payload->{'message'}) {
    $message = $payload->{'message'};
  } elsif (exists $payload->{'edited_message'}) {
    $message = $payload->{'edited_message'};
  }

  if(!%$message){
    return $self->render(json => {
      error => 'unhandled message-type'
    })
  }

  my $command = $message->{'text'};

  my $c = TwoFAuth::BotHandler->new();

  $c->setup();
  
  my $r = $c->match($command);
  my $response = $r->{action}($message);

  # Render template "example/welcome.html.ep" with message
  $self->render(json => $response);
}

1;


  

 

  