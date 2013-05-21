#!/usr/bin/perl

use utf8;
use warnings;
use strict;
use JSON;

my $zone       = "";
my @servers    = ("192.36.148.17", "2001:7fe::53");
my $known_good = "se.$zone";
my $known_bad  = "4089e55b9193d26bfbbf968ea1283fe93f01f755.$zone";
my $recursive  = "example.com";
my @transports = ("udp", "tcp");

my %template = (

    #'tcp_timeout' => 8,
    #'udp_timeout' => 3,

    # quick test timers
    'tcp_timeout' => 1,
    'retrans'     => 5,
    'retry'       => 2,

    # EDNS0 buffer size
    'bufsize' => 1400,
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

        # SOA without DO=1 (DNS02, DNS03, DNS07)
        $query{qname} = $zone;
        $query{qtype} = "SOA";
        $query{flags} = { do => 0, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # SOA with DO=1 (DNS02, DNS03, DNS07)
        $query{qname} = $zone;
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # NS (DNS05, DNS06, DNS08)
        $query{qname} = $zone;
        $query{qtype} = "NS";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # DNSKEY (DNS16)
        $query{qname} = $zone;
        $query{qtype} = "DNSKEY";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # DELEGATION resulting in referal (DNS09)
        $query{qname} = $known_good;
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # DELEGATION resulting in NXDOMAIN (DNS17)
        $query{qname} = $known_bad;
        $query{qtype} = "SOA";
        $query{flags} = { do => 1, cd => 0, rd => 0, ad => 0 };
        xmit(\%query);

        # RECURSION (DNS11)
        $query{qname} = $recursive;
        $query{qtype} = "SOA";
        $query{flags} = { do => 0, cd => 0, rd => 1, ad => 0 };
        xmit(\%query);
    }
}
