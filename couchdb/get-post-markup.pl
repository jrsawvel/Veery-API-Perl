#!/usr/bin/perl -wT

use lib '/home/veery/Veery-API-Perl/lib';

use CouchDB::Client;
use Data::Dumper;

my $rc;
my $c = CouchDB::Client->new();
$c->testConnection or die "The server cannot be reached";

$rc = $c->req('GET', 'veerydvlp1/_design/views/_view/post_markup?key="info"');
print Dumper $rc;
print "\n";

# my $stream = $rc->{'json'}->{'rows'};


