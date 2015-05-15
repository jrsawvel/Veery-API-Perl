package Searches;

use strict;
use warnings;

use App::SearchPosts;

sub searches {
    my $tmp_hash = shift;

    my $q = new CGI;

    my $request_method = $q->request_method();

    if ( $request_method eq "GET" ) {
        if ( $tmp_hash->{one} eq "tag" ) {
            SearchPosts::do_tag_search($tmp_hash);
        } elsif ( $tmp_hash->{one} eq "string" ) {
            SearchPosts::do_string_search($tmp_hash);
        }
    } 
    Error::report_error("400", "Not found", "Invalid request");  
}

1;

