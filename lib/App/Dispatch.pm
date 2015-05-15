package Dispatch;

use strict;
use warnings;

use App::Modules;
use App::RequestURI;

my %cgi_params = RequestURI::get_cgi_params_from_path_info("function", "one", "two", "three", "four");

my $dispatch_for = {
    posts              =>   sub { return \&do_sub(       "Posts",       "posts"                    ) },
    searches           =>   sub { return \&do_sub(       "Searches",    "searches"                 ) },
    users              =>   sub { return \&do_sub(       "Users",       "users"                    ) },
    showerror          =>   sub { return \&do_sub(       "Error",       "error"                    ) },
};

sub execute {
    my $function = $cgi_params{function};
    $dispatch_for->{showerror}->() if !defined $function;
    $dispatch_for->{showerror}->($function) unless exists $dispatch_for->{$function};
    defined $dispatch_for->{$function}->();
}

sub do_sub {
    my $module = shift;
    my $subroutine = shift;
    eval "require App::$module" or Error::report_error("500", "Runtime Error:", $@);
    my %hash = %cgi_params;
    my $coderef = "$module\:\:$subroutine(\\%hash)"  or Error::report_error("500", "Runtime Error:", $@);
    eval "{ &$coderef };"  or Error::report_error("500", "Runtime Error:", $@) ;
}

1;

