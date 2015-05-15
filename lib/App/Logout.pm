package Logout;

use strict;
use warnings;

sub logout {

    my $q   = new CGI;

    my $author_name = $q->param("author");
    my $session_id  = $q->param("session_id");

    my $config_author_name = Config::get_value_for("author_name");

    if ( $config_author_name ne $author_name ) {
        Error::report_error("400", "Unable to logout.", "Invalid info submitted.");    
    }

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");

    $rc = $c->req('GET', $db . '/' . $session_id);

    if ( $rc->{'success'} ) {
        if ( !$rc->{'json'} ) {
            Error::report_error("400", "Unable to logout.", "Invalid info submitted.");    
        } else {
            my $session_id_info = $rc->{'json'};
            my $id     = $session_id_info->{'_id'};
            my $status = $session_id_info->{'status'};

            if ( $status ne "active" ) {
                Error::report_error("400", "Unable to logout.", "Invalid info submitted.");    
            }
            if ( $id ne $session_id ) {
                Error::report_error("400", "Unable to logout.", "Invalid info submitted.");    
            }
            $session_id_info->{'status'} = "deleted";
            my $url      =  $db . "/" . $id;
            $rc = $c->req('PUT', $url, $session_id_info);
        }
    } else {
        Error::report_error("400", "Unable to logout.", "Invalid info submitted.");    
    }    

    my %hash;
    $hash{status}       = 200;
    $hash{description}  = "OK";
    $hash{logged_out}   = "true";

    my $json_return_str = JSON::encode_json \%hash;

    print CGI::header('application/json', '200 Accepted');
    print $json_return_str;
    exit;
}

1;

