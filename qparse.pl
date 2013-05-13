#!/usr/bin/perl

use strict;
use Net::DNS;
use Data::Dumper;
use MIME::Base64;
use JSON;

my $json = "";

while (<STDIN>) {
    $json .= $_;
}

my $blob = from_json($json);

#print Dumper($blob);

my $raw_query = decode_base64($blob->{query});
my $query     = new Net::DNS::Packet(\$raw_query);

my $raw_response = decode_base64($blob->{response});
my $response     = new Net::DNS::Packet(\$raw_response);

print "########################################\n";
print "#\n";
print "# JSON\n";
print "#\n";
print $json,"\n";

print "########################################\n";
print "#\n";
print "# QUERY\n";
print "#\n";
print $query->string;

print "########################################\n";
print "#\n";
print "# RESPONSE\n";
print "#\n";
print $response->string;
