#!/usr/bin/perl

use strict;
use Net::DNS;
use MIME::Base64;
use JSON;

while ( <STDIN> ) {
    chomp;
    my $json = $_;

    print STDERR "########## INPUT\n";
    print STDERR "\n";
    print STDERR "$json\n";
    print STDERR "\n";

    my $blob = from_json( $json );

    my $raw_query = decode_base64( $blob->{query} );
    my $query     = new Net::DNS::Packet( \$raw_query );

    my $raw_response = decode_base64( $blob->{response} );
    my $response     = new Net::DNS::Packet( \$raw_response );

    print STDERR "########## QUERY DUMP\n";
    print STDERR "\n";
    print STDERR $query->string;
    print STDERR "\n";

    print STDERR "########## RESPONSE DUMP\n";
    print STDERR "\n";
    print STDERR $response->string;

}
