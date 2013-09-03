# DNS Query Proxy

_dnsqproxy_ is a simple DNS query proxy that may be used to execute DNS queries
from remote servers. Queries and responses are communicated using JSON as
described in RFC 4627.

N.B.: This software is not indended to be used for public facing services such
as a DNS Looking Glass (e.g., https://github.com/bortzmeyer/dns-lg).


## Proxy Protocol

- Queries are submitted as JSON, one query per line.
- Responses are emitted as JSON, one response per line
- Multiple queries may be submitted in a single session.
- Session is terminated by an empty command or by end-of-file.


##  Query Elements

### Mandatory Query Elements

The following query elements must be specified and has no defaults.

- **address** -- IPv4/IPv6 address of the destination DNS server
- **qname** -- domain name to query
- **qtype** -- DNS resource record (RR) type

### Optional Query Elements

- **tag** -- query/response tag (no default)
- **port** -- destination port (default 53)
- **tcp_timeout** -- TCP timeout in seconds (default 60)
- **udp_timeout** -- UDP timeout in seconds (no default, retrans/retry used for
  retransmission)
- **retrans** -- retransmission interval (default 5)
- **retry** -- number of times to retry to query (default 2)
- **transport** -- TCP or UDP (default "UDP")
- **qclass** -- query class (default "IN")
- **bufsize** -- EDNS0 buffer size (default 512)
- **flags** -- query flags
    - **do** -- DNSSEC OK (default 0)
    - **cd** -- Checking Disabled (default 0)
    - **rd** -- Recursion Desired (default 0)
    - **ad** -- Authenticated Data (default 0)

## Response Elements

- **tag** -- query/response tag (if set in query)
- **address** -- IPv4/IPv6 address of destination DNS server
- **port** -- destination port
- **transport** -- TCP or UDP
- **time** -- query time in seconds
- **version** -- proxy version
- **query** -- full DNS query in Base64 format
- **response** -- full DNS response in Base64 format
- **error** -- error message (in case of error)

## Examples

    {"qtype":"SOA","qname":"github.com","address":"8.8.8.8","flags":{"rd":1}}

## Dependencies

The following perl modules are required:

- Data::Dumper
- IO::Socket::INET6
- JSON
- MIME::Base64
- Net::DNS
- Net::DNS::SEC
- Net::IP
- Time::HiRes

### Required Debian/Ubuntu Packages

- perl
- perl-base
- perl-modules
- libio-socket-inet6-perl
- libjson-perl
- libnet-dns-perl
- libnet-dns-sec-perl
- libnet-ip-perl
