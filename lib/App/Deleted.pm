package Deleted;

use App::Auth;

sub show_deleted_posts {

    my $q = new CGI;
    my $logged_in_author_name  = $q->param("author");
    my $session_id             = $q->param("session_id");
    if ( !Auth::is_valid_login($logged_in_author_name, $session_id) ) { 
        Error::report_error("400", "Unable to peform action.", "You are not logged in.");
    }

    my $rc;

    my $db = Config::get_value_for("database_name");

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("system", "Database error.", "The server cannot be reached.");

    $rc = $c->req('GET', $db . '/_design/views/_view/deleted_posts/?descending=true');

    my $deleted = $rc->{'json'}->{'rows'};

    my @posts;

    foreach my $hash_ref ( @$deleted ) {
        push(@posts, $hash_ref->{'value'});
    }

    my $hash_ref;
    $hash_ref->{status}      = 200;
    $hash_ref->{description} = "OK";
    $hash_ref->{posts}       = \@posts;
    my $json_str = JSON::encode_json $hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;
}

1;

