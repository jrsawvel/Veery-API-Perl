package Stream;

use strict;
use warnings;

sub read_stream {
    my $page_num    = shift;

    $page_num++ if $page_num == 0;

    my $rc;

    my $db = Config::get_value_for("database_name");

    my $c = CouchDB::Client->new();
    $c->testConnection or Error::report_error("500", "Database error.", "The server cannot be reached.");

    my $max_entries = Config::get_value_for("max_entries_on_page");

    my $skip_count = ($max_entries * $page_num) - $max_entries;

    my $couchdb_uri = $db . '/_design/views/_view/stream/?descending=true&limit=' . ($max_entries + 1) . '&skip=' . $skip_count;

    $rc = $c->req('GET', $couchdb_uri);

    my $stream = $rc->{'json'}->{'rows'};

    my $next_link_bool = 0;
    my $len = @$stream;
    $next_link_bool = 1 if $len > $max_entries;

    my @posts;

    my $ctr=0;
    foreach my $hash_ref ( @$stream ) {
        $hash_ref->{'value'}->{'formatted_updated_at'} = Utils::format_date_time($hash_ref->{'value'}->{'updated_at'});
        push(@posts, $hash_ref->{'value'});
        last if ++$ctr == $max_entries;
    }

    my $hash_ref;
    $hash_ref->{status}         = 200;
    $hash_ref->{description}    = "OK";
    $hash_ref->{next_link_bool} = $next_link_bool;
    $hash_ref->{posts}       = \@posts;
    my $json_str = JSON::encode_json $hash_ref;

    print CGI::header('application/json', '200 Accepted');
    print $json_str;
    exit;
}

1;
