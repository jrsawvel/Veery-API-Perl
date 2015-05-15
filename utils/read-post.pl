#!/usr/bin/perl -wT

use strict;

use lib '../lib';
use lib '../lib/CPAN';

use REST::Client;
use JSON::PP;
use HTML::Entities;
use Encode;

use App::Config;

my $api_url = Config::get_value_for("api_url");

my $rest = REST::Client->new();

$api_url .= "/posts/profile";

$rest->GET($api_url);

my $rc = $rest->responseCode();

print "rc = $rc\n";

print "response content =\n" . $rest->responseContent(); 


