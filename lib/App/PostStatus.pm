package PostStatus;

use strict;
use warnings;

use App::Auth;

sub change_post_status {
    my $action  = shift;
    my $post_id = shift;

    my $q = new CGI;
    my $logged_in_author_name  = $q->param("author");
    my $session_id             = $q->param("session_id");
    if ( !Auth::is_valid_login($logged_in_author_name, $session_id) ) { 
        Error::report_error("400", "Unable to peform action.", "You are not logged in.");
    }

    if ( $action ne "delete" and $action ne "undelete" ) {
        Error::report_error("400", "Unable to peform action.", "Invalid action submitted.");
    }

    my $db = Config::get_value_for("database_name");

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");

    $rc = $c->req('GET', $db . "/$post_id");

    if ( !$rc->{'json'} ) {
        Error::report_error("400", "Unable to delete post.", "Post ID \"$post_id\" was not found.");
    }

    my $perl_hash = $rc->{'json'};
    
    if ( !$perl_hash ) {
        Error::report_error("400", "Unable to delete post.", "Post ID \"$post_id\" was not found.");
    }

    $perl_hash->{'post_status'} = "deleted" if $action eq "delete";
    $perl_hash->{'post_status'} = "public"  if $action eq "undelete";

    $rc = $c->req('PUT', $db . "/$post_id", $perl_hash);

    my $hash_ref;
    $hash_ref->{status}           = 200;
    $hash_ref->{description}      = "OK";
    my $json_str = JSON::encode_json $hash_ref;
    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;
}

1;
