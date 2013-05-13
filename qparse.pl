#!/usr/bin/perl

use strict;
use Net::DNS;
use Data::Dumper;
use MIME::Base64;
use JSON;

while (<STDIN>) {
    my $json = $_;

    my $blob = from_json($json);

    #print Dumper($blob);

    my $raw_query = decode_base64($blob->{query});
    my $query     = new Net::DNS::Packet(\$raw_query);

    my $raw_response = decode_base64($blob->{response});
    my $response     = new Net::DNS::Packet(\$raw_response);

    print STDERR "RESPONSE $json\n";

    print STDERR "\n";
    print STDERR "########## QUERY\n";
    print STDERR "\n";
    print STDERR $query->string;

    print STDERR "\n";
    print STDERR "########## RESPONSE\n";
    print STDERR "\n";
    print STDERR $response->string;

}
