package Users;

use strict;
use warnings;

use App::Login;
use App::Logout;
use App::UserSettings;

sub users {

    my $tmp_hash = shift;

    my $q = new CGI;

    my $request_method = $q->request_method();

    if ( $request_method eq "POST" ) {
        if ( exists($tmp_hash->{one}) and $tmp_hash->{one} eq "login" ) {
            Login::create_and_send_no_password_login_link();
        }
    } elsif ( $request_method eq "PUT" ) {
        UserSettings::update_author_info();
    } elsif ( $request_method eq "GET" ) {
        if ( exists($tmp_hash->{one}) and $tmp_hash->{one} eq "login" ) {
            Login::activate_no_password_login();
        } elsif ( exists($tmp_hash->{one}) and $tmp_hash->{one} eq "logout" ) {
            Logout::logout();
        }
    }

    Error::report_error("400", "Invalid request or action", "Request method = $request_method. Action = $tmp_hash->{one}");

#    /* add GET for logout */

}

1;
