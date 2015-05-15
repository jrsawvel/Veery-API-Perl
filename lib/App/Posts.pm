package Posts;

use strict;
use warnings;

use App::Stream;
use App::ReadPost;
use App::CreatePost;
use App::UpdatePost;
use App::PostStatus;
use App::Deleted;

sub posts {
    my $tmp_hash = shift;

    my $page_num = 0;
    my $q = new CGI;
    $page_num = $q->param("page") if $q->param("page");

    my $request_method = $q->request_method();

    if ( $request_method eq "GET" and $tmp_hash->{one} and !$page_num ) {
        if ( $q->param("action") eq "delete"  or  $q->param("action") eq "undelete" ) {
            PostStatus::change_post_status($q->param("action"), $tmp_hash->{one});
        } elsif ( $q->param("deleted") eq "yes" ) {
            Deleted::show_deleted_posts();
        } else {
            # markup = return only the markup text. html = return only html. full = return all database data for the post.
            my $return_type = "html"; 
            $return_type    = $q->param("text") if $q->param("text");
            ReadPost::read_post($tmp_hash->{one}, $return_type);
        }
    } elsif ( $request_method eq "GET" ) {
        Stream::read_stream($page_num);

    } elsif ( $request_method eq "POST" ) {
        CreatePost::create_post();

    } elsif ( $request_method eq "PUT" ) {
        UpdatePost::update_post();

    }
    Error::report_error("400", "Not found", "Invalid request");  
}

1;


