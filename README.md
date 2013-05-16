# DNS Query Proxy

_dnsqproxy_ is a simple DNS query proxy that may be used to execute DNS queries
from remote servers. Queries and responses are communicated using JSON as
described in RFC 4627.

N.B.: This software is not indended to be used for public facing services such
as a DNS Looking Glass (e.g., https://github.com/bortzmeyer/dns-lg).

##  Query Elements

### Mandatory Query Elements

The following query elements must be specified and has no defaults.

- **address** -- IPv4/IPv6 address of the destination DNS server
- **qname** -- domain name to query
- **qtype** -- DNS resource record (RR) type

### Optional Query Elements

- **port** -- destination port (default 53)
- **tcp_timeout** -- TCP timeout in seconds (default 60)
- **udp_timeout** UDP timeout in seconds (default 60)
- **transport** -- TCP or UDP (default "UDP")
- **qclass** -- query class (default "IN")
- **bufsize** -- EDNS0 buffer size (default 512)
- **flags** -- query flags
    - **do** -- DNSSEC OK (default 0)
    - **cd** -- Checking Disabled (default 0)
    - **rd** -- Recursion Desired (default 0)
    - **ad** -- Authenticated Data (default 0)

## Response Elements

- **address** -- IPv4/IPv6 address of destination DNS server
- **port** -- destination port
- **transport** -- TCP or UDP
- **time** -- query time in seconds
- **version** -- proxy version
- **query** -- full DNS query in Base64 format
- **response** -- full DNS response in Base64 format
- **error** -- error message (in case of error)
