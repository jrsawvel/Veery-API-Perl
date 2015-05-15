package ReadPost;

use strict;
use warnings;

sub read_post {
    my $post_id     = shift; 
    my $return_type = shift;

    my $view_name;

    if ( $return_type eq "markup" ) {
        $view_name = "post_markup";
    } elsif ( $return_type eq "full" ) {
        $view_name = "post_full";
    } else {
        $view_name = "post";
    }
    
    my $post_hash = _get_post_data($post_id, $view_name);

    if ( !$post_hash ) {
        Error::report_error("404", "Post unavailable.", "Post ID not found: $post_id");
    }

    my $json_hash;
   
    $json_hash->{status}      = 200;
    $json_hash->{description} = "OK";
    $json_hash->{post}        = $post_hash;

    my $json_str = JSON::encode_json $json_hash;
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
