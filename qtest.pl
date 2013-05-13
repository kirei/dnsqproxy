#!/usr/bin/perl

use strict;
use JSON;

my @queries = (
    {
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
    },
    {
        address     => "8.8.8.8",
        port        => 53,
        tcp_timeout => 10,
        udp_timeout => 10,
        transport   => "udp",
        bufsize     => 1024,
        qname       => "kirei.se",
        qclass      => "IN",
        qtype       => "MX",
        flags       => { do => 1, cd => 0, rd => 1, ad => 0 },
    }
);

foreach my $json (map { to_json($_) } @queries) {
    print $json, "\n";
}
