=head1 NAME

    Net::Zabbix::Simple - simple zabbix API interface

=head1 SYNOPSIS

    use Net::Zabbix::Simple;

    my $result = zabbix_request('host.get', {
        search => {
            name => 'hostname',
        },
    }) or die zabbix_print_error();

    See Zabbix API Documentation:
        https://www.zabbix.com/documentation/2.4/manual/api/reference

=cut



package Net::Zabbix::Simple;

use strict;
use warnings;
use Data::Dumper;
use YAML::XS;
use Exporter;
use FindBin '$RealBin';
use lib "$RealBin/../lib";
use Net::Zabbix;

our @ISA = qw(Exporter);
our @EXPORT= qw(zabbix_request zabbix_print_error);
our @EXPORT_OK = qw($zabbix $zabbix_config_file $zabbix_config);

our $zabbix_config_file;

my @default_config_path_list = (
    "$RealBin/../etc/zabbix_config.yml",
    "$RealBin/../etc/zabbix_api.yml",
    "~/.zabbix_api.yml",
);

foreach (@default_config_path_list) {
    $zabbix_config_file = $_ if -e $_;
}

die "Your need make Zabbix API config file. See README\n"
            unless -e $zabbix_config_file;

open my $config_h, "<", $zabbix_config_file or
    die "Can't open $zabbix_config_file: $!\n";
our $zabbix_config = Load(join("", <$config_h>));
close $config_h;

our $zabbix = Net::Zabbix->new(
    $zabbix_config->{url},
    $zabbix_config->{username},
    $zabbix_config->{password},
);

sub zabbix_request {
    my ($object_operation, $params) = @_;
    my ($object, $operation) = split /\./, $object_operation;

    my $response = $zabbix->raw_request($object, $operation, $params);

    if ($response->{result}) {
        return $response->{result};
    } else {
        $@ = $response->{error};
        return undef;
    }
}

sub zabbix_print_error {
    if ($@) {
        print $@->{data} . "\n";
        print $@->{message} . "\n";
    } else {
        print Dumper($@);
    }
}

1;

