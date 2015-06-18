package SaveMarkup;

use strict;
use warnings;
use diagnostics;

sub save_markup {
    my $hash_ref = shift;

    my $save_markup = $hash_ref->{markup} .  "\n\n<!-- author: $hash_ref->{author} -->\n<!-- created_at: $hash_ref->{created_at} -->\n<!-- updated_at: $hash_ref->{updated_at} -->\n";

    # write markup to the file system.
    my $domain_name = Config::get_value_for("domain_name");
    my $markup_filename = Config::get_value_for("post_markup") . "/" . $domain_name . "-" . $hash_ref->{_id} . ".markup"; 
    if ( $markup_filename =~  m/^([a-zA-Z0-9\/\.\-_]+)$/ ) {
        $markup_filename = $1;
    } else {
        Error::report_error("500", "Bad file name.", "Could not write markup for post id: $hash_ref->{_id} filename: $markup_filename");
    }
    open FILE, ">$markup_filename" or Error::report_error("500", "Unable to open file for write.", "Post id: $hash_ref->{_id} filename: $markup_filename");
    print FILE $save_markup;
    close FILE;
}

1;
