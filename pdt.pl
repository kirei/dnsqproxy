#!/usr/bin/perl

use utf8;
use warnings;
use strict;
use JSON;

my $qname      = ".";
my @servers    = ("192.36.148.17", "2001:7fe::53");
my $nxdomain   = "4089e55b9193d26bfbbf968ea1283fe93f01f755";
my $recursive  = "example.com";
my @transports = ("udp", "tcp");

my %template = (

    #'tcp_timeout' => 8,
    #'udp_timeout' => 3,

    # quick test timers
    'tcp_timeout' => 1,
    'retrans'     => 5,
    'retry'       => 2,
);

sub xmit($) {
    my $json = to_json(shift);
    print STDERR "QUERY: ", $json, "\n";
    print $json, "\n";
}

foreach my $server (@servers) {
    foreach my $transport (@transports) {

        my %query = %template;

        $query{address}   = $server;
        $query{transport} = $transport;

        # SOA without DO=1
        $query{qname} = $qname;
        $query{qtype} = "SOA";
        $query{flags} = { do => 0, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # SOA with DO=1
        $query{qname} = $qname;
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # NS
        $query{qname} = $qname;
        $query{qtype} = "NS";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # DNSKEY
        $query{qname} = $qname;
        $query{qtype} = "DNSKEY";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # NXDOMAIN
        $query{qname} = sprintf("%s.%s", $nxdomain, $qname);
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # RECURSION
        $query{qname} = $recursive;
        $query{qtype} = "SOA";
        $query{flags} = { do => 0, cd => 0, rd => 1, ad => 0 };
        xmit(\%query);
    }
}
