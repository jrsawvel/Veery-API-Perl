#!/usr/bin/perl -wT

use CouchDB::Client;
use Data::Dumper;

    my $author_name = "MrX";

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or die "Database error. The server cannot be reached.";

    my $db = "scaupdvlp1";

    $rc = $c->req('GET', $db . '/_design/views/_view/author?key="' . $author_name . '"');

    if ( !$rc->{'json'}->{'rows'}->[0] ) {
        die "author not found.";
    } else {
        my $author_info = $rc->{'json'}->{'rows'}->[0]->{'value'};
        # $author_info->{'current_session_id'};
        print Dumper $author_info;
    }


