package ReadPost;

use strict;
use warnings;

use App::Auth;

sub read_post {
    my $post_id     = shift; 
    my $return_type = shift;


    my $q = new CGI;
    my $logged_in_author_name  = $q->param("author");
    my $session_id             = $q->param("session_id");
    my $is_logged_in = Auth::is_valid_login($logged_in_author_name, $session_id);


    my $view_name;

    if ( $return_type eq "markup" ) {
        $view_name = "post_markup";
    } elsif ( $return_type eq "full" ) {
        $view_name = "post_full";
    } else {
        $view_name = "post_html";
    }
    
    my $post_hash_ref = _get_post_data($post_id, $view_name);

    if ( !$post_hash_ref ) {
        Error::report_error("404", "Post unavailable.", "Post ID not found: $post_id");
    }

    delete($post_hash_ref->{'_rev'}) if !$is_logged_in;

    my $json_hash_ref;
   
    $json_hash_ref->{status}      = 200;
    $json_hash_ref->{description} = "OK";
    $json_hash_ref->{post}        = $post_hash_ref;

    my $json_str = JSON::encode_json $json_hash_ref;
    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;

}

sub _get_post_data {
    my $post_id   = shift;
    my $view_name = shift;

    my $ua = LWP::UserAgent->new;

    my $db = Config::get_value_for("database_name");

    my $url = "http://127.0.0.1:5984/" . $db . "/_design/views/_view/" . $view_name . "?key=\"$post_id\"";

    my $response = $ua->get($url);

    if ( !$response->is_success ) {
        Error::report_error("404", "Unable to display post.", "Post ID \"$post_id\" was not found.");
    }

    my $rc = JSON::decode_json $response->content;

    my $post = $rc->{'rows'}->[0]->{'value'};

    return $post;
}

1;
