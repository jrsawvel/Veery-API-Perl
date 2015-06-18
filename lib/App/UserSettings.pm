package UserSettings;

use strict;
use warnings;
use diagnostics;


use App::Auth;


# at the moment, the only item that can be modified is email address.
sub update_author_info {

    my $q = new CGI;

    my $json_input = $q->param('PUTDATA');

    my $input_hash_ref  = JSON::decode_json $json_input;

    my $logged_in_author_name  = $input_hash_ref->{'author'};
    my $logged_in_session_id   = $input_hash_ref->{'session_id'};

    if ( !Auth::is_valid_login($logged_in_author_name, $logged_in_session_id) ) { 
        Error::report_error("400", "Unable to peform action.", "You are not logged in.");
    }

    my $submitted_id  = $input_hash_ref->{'id'};
    my $submitted_rev = $input_hash_ref->{'rev'};

    my $old_email = Utils::trim_spaces($input_hash_ref->{'old_email'});
    my $new_email = Utils::trim_spaces($input_hash_ref->{'new_email'});

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");

    $rc = $c->req('GET', $db . '/_design/views/_view/author?key="' . $logged_in_author_name . '"');

    if ( !$rc->{'json'}->{'rows'}->[0] ) {
        Error::report_error("400", "Unable to complete action.", "Author not found.");
    }

    my $author_info = $rc->{'json'}->{'rows'}->[0]->{'value'};

    if ( $logged_in_session_id ne $author_info->{'current_session_id'} ) {
        Error::report_error("400", "Unable to peform action.", "You are not logged in.");
    }

    if ( !Utils::is_valid_email($old_email) ) {
        Error::report_error("400", "Unable to peform action.", "Invalid syntax for old email address provided.");
    }
 
    if ( !Utils::is_valid_email($new_email) ) {
        Error::report_error("400", "Unable to peform action.", "Invalid syntax for new email address provided.");
    }

    if ( lc($old_email) eq lc($new_email) ) {
        Error::report_error("400", "Unable to peform action.", "The provided old and new email addresses are identical.");
    }

    if ( $old_email ne $author_info->{'email'} ) {
        Error::report_error("400", "Unable to peform action.", "The provided old email address does not match the email address contained in the database.");
    }

    if ( $submitted_id ne $author_info->{'_id'} ) {
        Error::report_error("400", "Unable to peform action.", "Invalid user information provided. (A)");
    }

    if ( $submitted_rev ne $author_info->{'_rev'} ) {
        Error::report_error("400", "Unable to peform action.", "Invalid user information provided. (B)");
    }

    $author_info->{'email'} = $new_email;

    $rc = $c->req('PUT', $db . "/$author_info->{_id}", $author_info);
    if ( $rc->{status} >= 300 ) {
        Error::report_error("400", "Unable to update author info.", $rc->{msg});
    }

    my $output_hash_ref;
    $output_hash_ref->{status}      = 200;
    $output_hash_ref->{description} = "OK";

    my $json_output = JSON::encode_json $output_hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_output;
    exit;
}

sub get_user_info {
    my $author_name = shift;

    if ( !$author_name ) {
        Error::report_error("400", "Unable to complete action.", "Author name was missing.");
    }

    my $q   = new CGI;

    my $logged_in_author_name = $q->param("author");
    my $logged_in_session_id  = $q->param("session_id");

    my $is_logged_in = 0;

    if ( Auth::is_valid_login($logged_in_author_name, $logged_in_session_id) ) { 
        $is_logged_in = 1;
    }

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");

    $rc = $c->req('GET', $db . '/_design/views/_view/author?key="' . $author_name . '"');

    if ( !$rc->{'json'}->{'rows'}->[0] ) {
        Error::report_error("400", "Unable to complete action.", "Author not found. $author_name");
    }

    my $author_info = $rc->{'json'}->{'rows'}->[0]->{'value'};

    if ( !$is_logged_in ) {
        delete($author_info->{'_id'});
        delete($author_info->{'_rev'});
        delete($author_info->{'email'});
        delete($author_info->{'current_session_id'});
    }

    $author_info->{is_logged_in}= $is_logged_in;
    $author_info->{status}      = 200;
    $author_info->{description} = "OK";

    my $json_output = JSON::encode_json $author_info;

    print CGI::header('application/json', '200 Accepted');
    print $json_output;
    exit;

}


1;

__END__

returned JSON from the CouchDB view that retrieves the author's info:

{
    "_id"  : "abbe7c5d810006f8",
    "_rev" : "12-90b9a5ae6c32d",
    "type" : "author",
    "name" : "MrX",
    "email" : "mrx@mrx.xyz",
    "current_session_id" : "5aabbe7c5d8103411c"
}
