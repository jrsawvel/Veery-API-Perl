package UpdatePost;

# todo consolidate redudancy with CreatePost ???

use strict;
use warnings;

use HTML::Entities;
use URI::Escape::JavaScript qw(escape unescape);
use App::Auth;
use App::PostTitle;
use App::Format;

sub update_post {

    my $q = new CGI;

    my $json_text = $q->param('PUTDATA');

    my $hash_ref = JSON::decode_json $json_text;

    my $logged_in_author_name  = $hash_ref->{'author'};
    my $session_id             = $hash_ref->{'session_id'};

    my $author                 = Config::get_value_for("author_name");
    my $db                     = Config::get_value_for("database_name");

    if ( !Auth::is_valid_login($logged_in_author_name, $session_id) ) { 
        Error::report_error("400", "Unable to peform action.", "You are not logged in.");
    }

    my $submit_type     = $hash_ref->{'submit_type'}; # Update or Preview
    if ( $submit_type ne "Update" and $submit_type ne "Preview" ) {
        Error::report_error("400", "Unable to process post.", "Invalid submit type given.");
    } 

    my $original_markup = $hash_ref->{'markup'};
    my $rev             = $hash_ref->{'rev'};
    my $post_id         = $hash_ref->{'post_id'};

    my $markup = Utils::trim_spaces($original_markup);
    if ( !defined($markup) || length($markup) < 1 ) {
        Error::report_error("400", "Invalid post.", "You most enter text.");
    } 

# why is this section different from the CreatePost.pm?
    my $formtype = $hash_ref->{'form_type'};
    if ( $formtype eq "ajax" ) {
        $markup = URI::Escape::JavaScript::unescape($markup);
    } else {
        $markup = Encode::decode_utf8($markup);
    }
    $markup = HTML::Entities::encode($markup, '^\n\x20-\x25\x27-\x7e');

    my $o = PostTitle->new();
    $o->process_title($markup);
    if ( $o->is_error() ) {
        Error::report_error("400", "Error creating post.", $o->get_error_string());
    } 
    my $title           = $o->get_post_title();
    my $post_type       = $o->get_content_type(); # article or note
    # my $slug            = $o->get_slug();
    my $slug            = $post_id;
    my $html            = Format::markup_to_html($markup, $o->get_markup_type(), $slug);

    my $hash_ref;

    if ( $submit_type eq "Preview" ) {
        $hash_ref->{html} = $html;
        $hash_ref->{status}      = 200;
        $hash_ref->{description} = "OK";
        my $json_str = JSON::encode_json $hash_ref;
        print CGI::header('application/json', '200 Accepted');
        print $json_str;
        exit;
    }

    my $tmp_post = $html;
    $tmp_post =~ s|<more />|\[more\]|;
    $tmp_post =~ s|<h1 class="headingtext">|\[h1\]|;
    $tmp_post =~ s|</h1>|\[/h1\]|;

    $tmp_post           = Utils::remove_html($tmp_post);
    my $post_stats      = Format::calc_reading_time_and_word_count($tmp_post); #returns a hash ref
    my $more_text_info  = Format::get_more_text_info($tmp_post, $slug, $title); #returns a hash ref
    my @tags            = Format::create_tag_array($markup);
    my $updated_at      = Utils::create_datetime_stamp();

    my $previous_post_hash = _get_entire_post($post_id); #returns a hash ref

    if ( $previous_post_hash->{'_rev'} ne $rev ) {
        Error::report_error("400", "Unable to update post.", "Invalid rev information provided."); 
    }

    $previous_post_hash->{'title'}             = $title;
    $previous_post_hash->{'markup'}            = $markup;
    $previous_post_hash->{'html'}              = $html;
    $previous_post_hash->{'text_intro'}        = $more_text_info->{'text_intro'};
    $previous_post_hash->{'more_text_exists'}  = $more_text_info->{'more_text_exists'};
    $previous_post_hash->{'post_type'}         = $post_type;
    $previous_post_hash->{'tags'}              = \@tags;
    $previous_post_hash->{'updated_at'}        = $updated_at;
    $previous_post_hash->{'reading_time'}      = $post_stats->{'reading_time'};
    $previous_post_hash->{'word_count'}        = $post_stats->{'word_count'};


    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");
    my $rc = $c->req('PUT', $db . "/$post_id", $previous_post_hash);
    if ( $rc->{status} >= 300 ) {
        Error::report_error("400", "Unable to update post.", $rc->{msg});
    }


    if ( Config::get_value_for("write_html_to_memcached") ) {
        Post::_write_html_to_memcached($post_id);
    }


    $hash_ref->{rev}         = $rc->{json}->{rev};
    $hash_ref->{html}        = $html;
    $hash_ref->{status}      = 200;
    $hash_ref->{description} = "OK";
    my $json_str = JSON::encode_json $hash_ref;
    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;

}

sub _get_entire_post {
    my $post_id = shift;

    my $db = Config::get_value_for("database_name");

    my $rc;

    my $c = CouchDB::Client->new();
    $c->testConnection or Page->report_error("system", "Database error.", "The server cannot be reached.");

    $rc = $c->req('GET', $db . "/$post_id");

    if ( !$rc->{'json'} ) {
        Error::report_error("400", "Unable to get post.", "Post ID \"$post_id\" was not found.");
    }

    my $perl_hash = $rc->{'json'};
    
    if ( !$perl_hash ) {
        Error::report_error("400", "Unable to get post.", "Post ID \"$post_id\" was not found.");
    }

    return $perl_hash;
}

1;

