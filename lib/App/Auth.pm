package Auth;

use strict;
use warnings;

sub is_valid_login {
    my $submitted_author_name = shift;
    my $submitted_session_id  = shift;

    my $author_name = Config::get_value_for("author_name");
    return 0 if $submitted_author_name ne $author_name;

    # from the user doc
    my $current_session_id = _get_session_id_for($author_name);
    return 0 if $submitted_session_id ne $current_session_id;

    # check to ensure the current_session_id is active in the session_id doc
    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Page->report_error("system", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");

    $rc = $c->req('GET', $db . '/' . $submitted_session_id);
    my $session_info = $rc->{'json'};

    return 0 if $session_info->{'status'} ne "active";

    # may use this info later if activie session ids are given an expiration date
      my $created_at  = $session_info->{'created_at'};
      my $updated_at  = $session_info->{'updated_at'};

    return 1;

}

sub _get_session_id_for {
    my $author_name = shift;

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Page->report_error("system", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");
    $rc = $c->req('GET', $db . '/_design/views/_view/author?key="' . $author_name . '"');

    if ( !$rc->{'json'}->{'rows'}->[0] ) {
        return " ";
    } else {
        my $author_info = $rc->{'json'}->{'rows'}->[0]->{'value'};
        return $author_info->{'current_session_id'};
    }
}

1;
