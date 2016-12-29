#!/usr/bin/perl

#-------------------------------------------------------------------------------

my $freedns_afraid_org_token = "<your afraid-dyndns TOKEN>";
my $email_addreses="<e-mail 1>,<e-mail 2>";
my $ipfile    = '/var/log/freedns-afraid-org-IP.txt';
my $check_ip_bot = "bot.whatismyipaddress.com";
my $check_period = 300;
my $use_curl_to_get_ip = 1;


#-------------------------------------------------------------------------------







use Sys::Hostname;

print "\nFreeDNS.Afraid.org Dynamic IP updater v1.0\n(c)Piotr Oniszczuk\n\n";
print "  -Check period : ".$check_period."sec\n";
print "  -IP log file  : ".$ipfile."\n";

my $initial_info = 1;

while (1) {

    open S, "$ipfile";
    $prev_ip = <S>;
    close S;
    if (length($prev_ip) == 0) {
        $prev_ip = "Unknown";
    }

    if ($use_curl_to_get_ip) {
        $ip = `curl -ks $check_ip_bot`;
    }
    else {
        ($name,$aliases,$addrtype,$length,@addrs) = gethostbyname(Sys::Hostname::ghname());
        ($a,$b,$c,$d) = unpack('C4',$addrs[0]);
        $ip = "$a.$b.$c.$d";
    }

    if ($initial_info) {
        print "  -Previous IP  : ".$prev_ip."\n";
        print "  -Current IP   : ".$ip."\n\n";
        $initial_info = 0;
    }

    if (!($ip eq $prev_ip)) {

        if ($ip) {

            print "Public IP changed...\n";
            print "  Old IP: $prev_ip\n";
            print "  New IP: $ip\n";

            print "Updating freedns.afraid.org with new IP...\n";
            system("curl -ks http://freedns.afraid.org/dynamic/update.php?$freedns_afraid_org_token");
            print "\nDone...\n";

            open S, ">$ipfile";
            print S $ip;
            close S;

            print "Sending notify E-Mails...\n";
            system("printf \"Home Server has new Internet public IP address!\n\nOld IP address : $prev_ip\nNew IP address : $ip\n\" | mail -v -s \"Home Server: New Internet Public IP address\" $email_addreses 2>&1");
        }
        else {
            print "ERROR: Can't get current IP from $check_ip_bot\n";
            sleep (3600);
        }
    }

    sleep($check_period);
}

