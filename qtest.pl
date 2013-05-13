#!/usr/bin/perl

use strict;
use JSON;

my $q1 = {
    address     => "8.8.8.8",
    port        => 53,
    tcp_timeout => 10,
    udp_timeout => 10,
    transport   => "udp",
    bufsize     => 1024,
    qname       => "kirei.se",
    qclass      => "IN",
    qtype       => "SOA",
    flags       => { do => 1, cd => 0, rd => 1, ad => 0 },
};

my $json = to_json($q1);

print STDERR "QUERY $json\n";

print $json, "\n";
