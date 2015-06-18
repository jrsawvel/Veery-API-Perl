package Login;

use strict;
use warnings;

use WWW::Mailgun;

sub create_and_send_no_password_login_link {

    my $q = new CGI;

    my $json_text = $q->param('POSTDATA');

    my $hash_ref_login = JSON::decode_json $json_text;

    my $user_submitted_email = Utils::trim_spaces($hash_ref_login->{'email'});
    my $client_url           = Utils::trim_spaces($hash_ref_login->{'url'});

    if ( !$user_submitted_email or !$client_url ) {
        Error::report_error("400", "Invalid input.", "Insufficent data was submitted.");
    }

    my $author_name  = Config::get_value_for("author_name");
    my $author_email = _get_email_for($author_name);

    my $rev = "";

    if ( $user_submitted_email ne $author_email ) {
        Error::report_error("400", "Invalid input.", "Data was not found.");
    } else {
        $rev = _create_session_id(); 
        _send_login_link($author_email, $rev, $client_url);
    }

    my $hash_ref;

    $hash_ref->{session_id_rev} = $rev if Config::get_value_for("debug_mode"); 

    $hash_ref->{status}          = 200;
    $hash_ref->{description}     = "OK";
    $hash_ref->{user_message}    = "Creating New Login Link";
    $hash_ref->{system_message}  = "A new login link has been created and sent.";

    my $json_str = JSON::encode_json $hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;
}

sub _send_login_link {
    my $email_rcpt      = shift;
    my $rev             = shift;
    my $client_url      = shift;

    my $date_time = Utils::create_datetime_stamp();

    my $mailgun_api_key = Config::get_value_for("mailgun_api_key");
    my $mailgun_domain  = Config::get_value_for("mailgun_domain");
    my $mailgun_from    = Config::get_value_for("mailgun_from");

    my $home_page = Config::get_value_for("home_page");
    my $link      = "$client_url/$rev";

    my $site_name = Config::get_value_for("site_name");
    my $subject = "$site_name Login Link - $date_time UTC";

    my $message = "Clink or copy link to log into the site.\n\n$link\n";

    my $mg = WWW::Mailgun->new({ 
        key    => "$mailgun_api_key",
        domain => "$mailgun_domain",
        from   => "$mailgun_from"
    });

    $mg->send({
          to      => "<$email_rcpt>",
          subject => "$subject",
          text    => "$message"
    });

}

sub _get_email_for {

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
        return $author_info->{'email'};
    }
}

sub _create_session_id {

    my $created_at = Utils::create_datetime_stamp();
    my $updated_at = $created_at;

    my $cdb_hash = {
        'type'              =>  'session_id',
        'created_at'        =>  $created_at,
        'updated_at'        =>  $updated_at,
        'status'            =>  'pending'
    };

    my $c = CouchDB::Client->new();
    $c->testConnection or Page->report_error("system", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");
    my $rc = $c->req('POST', $db, $cdb_hash);

    if ( $rc->{'json'}->{'rev'} ) {
        return $rc->{'json'}->{'rev'};
    } else {
        return " ";
    }
}

sub activate_no_password_login {

    my $q   = new CGI;

    my $rev = $q->param("rev");

    my $error_exists = 0;

    my $session_id = _get_session_id($rev);

    if ( !$session_id ) {
        Error::report_error("400", "Unable to login.", "Invalid session information submitted.");
    }

    my $savepassword    = "no";

    my $hash_ref;

    $hash_ref->{author_name} = Config::get_value_for("author_name");
    $hash_ref->{session_id}  = $session_id;
    $hash_ref->{status}           = 200;
    $hash_ref->{description}      = "OK";

    my $json_str = JSON::encode_json $hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;
}


# update couchdb to change status for the session id from pending to active
# and return the session id.
sub _get_session_id {
    my $user_submitted_rev = shift;

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Page->report_error("system", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");

    $rc = $c->req('GET', $db . '/_design/views/_view/session_id?key="'. $user_submitted_rev. '"');

    if ( $rc->{'success'} ) {
        if ( !$rc->{'json'}->{'rows'}->[0] ) {
            return 0;
        } else {
            my $session_id_info = $rc->{'json'}->{'rows'}->[0]->{'value'};
            my $id     = $session_id_info->{'_id'};
            my $rev    = $session_id_info->{'_rev'};
            my $status = $session_id_info->{'status'};
            if ( $status ne "pending" ) {
                return 0;
            }
            if ( $rev ne $user_submitted_rev ) {
                return 0;
            }
            $session_id_info->{'status'}     = "active";
            $session_id_info->{'updated_at'} = Utils::create_datetime_stamp();
            my $url      =  $db . "/" . $id;
            $rc = $c->req('PUT', $url, $session_id_info);
            _update_user_current_session_id($id);
            return $id;
        }
    } else {
        return 0;
    }    
}

sub _update_user_current_session_id {
    my $session_id = shift;

    my $author_name = Config::get_value_for("author_name");
    
    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Page->report_error("system", "Database error.", "The server cannot be reached.");

    my $db = Config::get_value_for("database_name");
    $rc = $c->req('GET', $db . '/_design/views/_view/author?key="' . $author_name . '"');

    if ( !$rc->{'json'}->{'rows'}->[0] ) {
        return " ";
    } else {
        my $author_info = $rc->{'json'}->{'rows'}->[0]->{'value'};
        $author_info->{'current_session_id'} = $session_id;
        my $url      =  $db . "/" . $author_info->{'_id'};
        $rc = $c->req('PUT', $url, $author_info);
    }
}


1;
