package Modules;
use strict;
use warnings;
use diagnostics;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);
use CouchDB::Client;
use JSON::PP;
use App::Config;
use App::Utils;
use App::Error;
1;
