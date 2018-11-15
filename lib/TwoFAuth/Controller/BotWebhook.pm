package TwoFAuth::Controller::BotWebhook;
use feature 'say';
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(from_json);

use TwoFAuth::BotHandler;
use TwoFAuth::BotAPI;

# This action will render a template
sub callback {
  my $self = shift;
  
  my $bot = TwoFAuth::BotAPI->new(
    bot_token => $self->config->{'bot_token'},
  );

  my $bot_controller = TwoFAuth::BotHandler->new(
    bot => $bot,
    mojo_ctx => $self,
  );
  $bot_controller->setup_router();

  my $update = '{"update_id":48585929, "message":{"message_id":13,"from":{"id":150783092,"is_bot":false,"first_name":"Jose","last_name":"Gomez","username":"josegomezr","language_code":"en-US"},"chat":{"id":150783092,"first_name":"Jose","last_name":"Gomez","username":"josegomezr","type":"private"},"date":1542241597,"text":"/start 12344"}}';

  our $payload = from_json $update;

  if( 0 ){
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

  my $matched_route = $bot_controller->match($message);
  my $response = $matched_route->{action}();

  # Render template "example/welcome.html.ep" with message
  $self->render(text => $response);
}

1;


  

 

  