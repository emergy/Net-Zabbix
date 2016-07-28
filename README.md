Net::Zabbix is simple and thin layer between Zabbix API and your code. It
doesn't implement much, except authentication and request counting. There
are few helper methods to simplify calling methods such as
create/get/update/delete/exists. There is no checking of method parameters,
as that is work for-and already implemented on server side.

Consult Zabbix API documentation for details.

- https://www.zabbix.com/documentation/2.4/manual/api/reference
- https://www.zabbix.com/documentation/3.0/manual/api/reference

### Note

Module is fully compatible with Zabbix 3.0 and 1.8.

### Example

This will list hosts like '*test*', limited only by access level for API
user. So, remember to add user to appropriate groups and assign enough
permissions.

```perl
use Net::Zabbix;

my $z = Net::Zabbix->new("http://server/zabbix", "API", "calvin", 1);
my $r = $z->get("host", {
        filter => undef,
        search => {
            host => "test",
        },
    }
);

```

### Example 2

Place config zabbix_api.yml to project/etc ($RealBin/../etc)

```yml
url: "https://zabbix.host.corp"
username: "api"
password: "p@$$w0rd"

```

and use simple syntax

```perl
use Net::Zabbix::Simple;

my $result = zabbix_request('host.get', {
    search => {
        name => 'hostname',
    },
}) or die zabbix_print_error();

```

### License

Code diverged a lot from original branch. Consider my additions as WTF-PL.

