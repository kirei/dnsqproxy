#!/usr/bin/perl

use utf8;
use warnings;
use strict;
use JSON;

my $zone    = "se";
my @servers = (
    "192.36.144.107",           # a.ns.se.
    "2a01:3f0:0:301::53",       # a.ns.se.
    "192.36.133.107",           # b.ns.se.
    "2001:67c:254c:301::53",    # b.ns.se.
    "192.36.135.107",           # c.ns.se.
    "2001:67c:2554:301::53",    # c.ns.se.
    "81.228.8.16",              # d.ns.se.
    "81.228.10.57",             # e.ns.se.
    "192.71.53.53",             # f.ns.se.
    "2a01:3f0:0:305::53",       # f.ns.se.
    "130.239.5.114",            # g.ns.se.
    "2001:6b0:e:3::1",          # g.ns.se.
    "194.146.106.22",           # i.ns.se.
    "2001:67c:1010:5::53",      # i.ns.se.
    "199.254.63.1",             # j.ns.se.
    "2001:500:2c::1",           # j.ns.se.
);

my $known_good = "kirei.$zone";
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
