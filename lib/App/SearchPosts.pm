package SearchPosts;

use strict;
use warnings;

use URI::Escape;

sub do_string_search {
    my $tmp_hash = shift;  

    my $keyword = $tmp_hash->{two};

    my $page_num = 1;

    my $q = new CGI;

    if ( Utils::is_numeric($q->param("page")) ) {
        $page_num = $q->param("page");
    }

    if ( !defined($keyword) ) {
        my $q = new CGI;
        $keyword = $q->param("keywords");

        if ( !defined($keyword) ) {
            Error::report_error("400", "Missing data.", "Enter keyword(s) to search on.");
        }
        
        $keyword = Utils::trim_spaces($keyword);
        if ( length($keyword) < 1 ) {
            Error::report_error("400", "Missing data.", "Enter keyword(s) to search on.");
        }
        
    }

    $keyword = uri_unescape($keyword);

    # if the more friendly + signs are used for spaces in query string instead of %20, deal with it here.
    # $keyword =~ s/\+/ /g;


    my $db = Config::get_value_for("database_name");

    my $max_entries = Config::get_value_for("max_entries_on_page");

    my $skip_count = ($max_entries * $page_num) - $max_entries;

    my $url = 'http://127.0.0.1:9200/' . $db . '/' . $db . '/_search?size=' . $max_entries . '&q=%2Btype%3Apost+%2Bpost_status%3Apublic+%2Bmarkup%3A' . uri_escape($keyword) . '&from=' . $skip_count;

    my $ua = LWP::UserAgent->new;

    my $response = $ua->get($url);
    if ( !$response->is_success ) {
        Error::report_error("400", "Unable to complete request.", "$url");
    }

    my $rc = JSON::decode_json $response->content;

    my $total_hits = $rc->{'hits'}->{'total'};

    my $stream = $rc->{'hits'}->{'hits'};

    my @posts;

    foreach my $hash_ref ( @$stream ) {
        $hash_ref->{'_source'}->{'formatted_updated_at'} = Utils::format_date_time($hash_ref->{'_source'}->{'updated_at'});
        $hash_ref->{'_source'}->{'slug'} = $hash_ref->{'_source'}->{'_id'};

        delete($hash_ref->{'_source'}->{'_id'});
        delete($hash_ref->{'_source'}->{'created_at'});
        delete($hash_ref->{'_source'}->{'html'});
        delete($hash_ref->{'_source'}->{'markup'});
        delete($hash_ref->{'_source'}->{'_rev'});
        delete($hash_ref->{'_source'}->{'post_status'});
        delete($hash_ref->{'_source'}->{'type'});
        delete($hash_ref->{'_source'}->{'word_count'});

        push(@posts, $hash_ref->{'_source'});
    }

    my $hash_ref;
    $hash_ref->{next_link_bool} = 0;

    my $len = @$stream;
    if ( ($len == $max_entries) && ($total_hits > $max_entries) ) {
        $hash_ref->{next_link_bool} = 1;
    }

    $hash_ref->{status}      = 200;
    $hash_ref->{description} = "OK";
    $hash_ref->{posts}       = \@posts;
    my $json_str = JSON::encode_json $hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;
}

sub do_tag_search {
    my $tmp_hash = shift;  

    my $keyword = $tmp_hash->{two};

    my $page_num = 1;

    my $q = new CGI;

    if ( Utils::is_numeric($q->param("page")) ) {
        $page_num = $q->param("page");
    }

    my $rc;

    my $db = Config::get_value_for("database_name");

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");

    my $max_entries = Config::get_value_for("max_entries_on_page");

    my $skip_count = ($max_entries * $page_num) - $max_entries;

    my $couchdb_uri = $db . "/_design/views/_view/tag_search?descending=true&limit=" . ($max_entries + 1) . "&skip=" . $skip_count;
    $couchdb_uri = $couchdb_uri . "&startkey=[\"$keyword\", {}]&endkey=[\"$keyword\"]";

    $rc = $c->req('GET', $couchdb_uri);

    my $stream = $rc->{'json'}->{'rows'};

    my $hash_ref;

    $hash_ref->{next_link_bool} = 0;
    my $len = @$stream;
    if ( $len > $max_entries ) {
        $hash_ref->{next_link_bool} = 1;
    }

    my @posts;

    my $ctr=0;
    foreach my $hash_ref ( @$stream ) {
        $hash_ref->{'value'}->{'formatted_updated_at'} = Utils::format_date_time($hash_ref->{'value'}->{'updated_at'});
        push(@posts, $hash_ref->{'value'});
        last if ++$ctr == $max_entries;
    }

    $hash_ref->{status}      = 200;
    $hash_ref->{description} = "OK";
    $hash_ref->{posts}       = \@posts;
    my $json_str = JSON::encode_json $hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;

}

1;

