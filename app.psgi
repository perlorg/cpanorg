# THIS app.psgi is just for development, NOT deployment

use strict;
use warnings;

use Path::Class;
use Plack::Builder;
use Plack::App::TemplateToolkit;
use Plack::Middleware::Static;

my $root   = dir( 'html' )->stringify();

my $app = Plack::App::TemplateToolkit->new(
    root => [ ( $root ) ],
)->to_app;

$app = Plack::Middleware::Static->wrap(
    $app,
    path         => qr{[gif|png|jpg|swf|ico|mov|mp3|pdf|js|css]$},
    root         => $root,
);


return builder {
    $app;
}