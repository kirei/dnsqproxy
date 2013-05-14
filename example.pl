#!/usr/bin/perl

use strict;
use JSON;

my $query = {
    address     => "8.8.8.8",
    port        => 53,
    tcp_timeout => 10,
    udp_timeout => 10,
    transport   => "udp",
    bufsize     => 1024,
    qname       => "kirei.se",
    qclass      => "IN",
    qtype       => "SOA",
    flags       => { do => 0, cd => 0, rd => 1, ad => 0 },
};

print to_json($query), "\n";
