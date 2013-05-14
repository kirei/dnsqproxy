#!/usr/bin/perl

use strict;
use JSON;

my $qname    = ".";
my @servers  = ("192.36.148.17", "2001:7fe::53");
my $nxdomain = "4089e55b9193d26bfbbf968ea1283fe93f01f755";

my %template = (

    #'tcp_timeout' => 8,
    #'udp_timeout' => 3,

    # quick test timers
    'tcp_timeout' => 1,
    'udp_timeout' => 1,
);

foreach my $server (@servers) {
    foreach my $transport ("udp", "tcp") {

        my %query = %template;

        $query{address}   = $server;
        $query{transport} = $transport;
        $query{qclass}    = "IN";

        # SOA without DO=1
        $query{qname} = $qname;
        $query{qtype} = "SOA";
        $query{flags} = { do => 0, cd => 0, rd => 0, ad => 0 };
        print to_json(\%query), "\n";

        # SOA with DO=1
        $query{qname} = $qname;
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        print to_json(\%query), "\n";

        # NS
        $query{qname} = $qname;
        $query{qtype} = "NS";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        print to_json(\%query), "\n";

        # DNSKEY
        $query{qname} = $qname;
        $query{qtype} = "DNSKEY";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        print to_json(\%query), "\n";

        # NXDOMAIN
        $query{qname} = sprintf("%s.%s", $nxdomain, $qname);
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        print to_json(\%query), "\n";

        # RECURSION
        $query{qname} = "icann.org";
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 1, ad => 0 };
        print to_json(\%query), "\n";
    }
}
