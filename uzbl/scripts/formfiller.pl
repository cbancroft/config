#!/usr/bin/perl

# a slightly more advanced form filler
#
# uses settings file like: $keydir/<domain>
#TODO: fallback to $HOME/.local/share
# user arg 1:
# edit: force editing of the file (fetches if file is missing)
# load: fill forms from file (fetches if file is missing)
# new:  fetch new file

# usage example:
# bind LL = spawn /usr/share/uzbl/examples/data/scripts/formfiller.pl load
# bind LN = spawn /usr/share/uzbl/examples/data/scripts/formfiller.pl new
# bind LE = spawn /usr/share/uzbl/examples/data/scripts/formfiller.pl edit

use strict;
use warnings;

my $keydir = $ENV{XDG_CONFIG_HOME} . "/uzbl/forms";
my ($fifoname, $url) = @ENV{qw(UZBL_FIFO UZBL_URI)};
my $cmd = $ARGV[0];
if (!defined $fifoname || $fifoname eq "") { die "No fifo"; }

sub domain {
    my ($url) = @_;
  $url =~ s#http(s)?://([A-Za-z0-9\.-]+)(/.*)?#$2#;
  return $url;
};

my @editor = ('urxvtc', '-e', $ENV{XDG_CONFIG_HOME}.'/uzbl/scripts/enc-vim');

# ideally, there would be some way to ask uzbl for the html content instead of having to redownload it with
#Also, you may need to fake the user-agent on some sites (like facebook)
my $downloader = "curl -k -A 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.10) Gecko/2009042810 GranParadiso/3.0.10' ";
#my $downloader = "curl -s";

my @fields = ("type","name","value");

my %command;

$command{load} = sub {
    my ($domain) = @_;
    my $filename = "$keydir/$domain";
    if (-e $filename){
	open(my $file, '-|', 'gpg', '--batch', '--no-tty', '-d', $filename) or die "Failed to open $filename: $!";
	my (@lines) = <$file>;
	my $active = 1;
	close($file);
	$|++;
	open(my $fifo, ">>", $fifoname) or die "Failed to open $fifoname: $!";
	foreach my $line (@lines) {
      next if ($line =~ m/^#/);
	       if ($line =~ /^\s*>(.*\S)\s*$/) {
		   $active = $url =~ /$1/;
		   next;
	       }
	       next unless $active;
	       $line =~ s/@/\\@/g;
	       my ($type,$name,$value) = ($line =~ /^\s*(\w*)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*$/);
      if ($type eq "checkbox")
	       {
		   printf $fifo 'js document.getElementsByName("%s")[0].checked = %s;'."\n", $name, $value;
	       } elsif ($type eq "submit") {
		   printf $fifo 'js try { document.getElementsByName("%s")[0].click(); } catch(err) { document.getElementById("%s").click(); }'."\n", $name, $name;
	       } elsif ($type eq "form") {
		   printf $fifo 'js try { document.getElementsByName("%s")[0].submit(); } catch(err) { document.getElementById("%s").submit(); }'."\n", $name, $name;
	       } else {
		   printf $fifo 'js document.getElementsByName("%s")[0].value = "%s";'."\n", $name, $value;
	       }
	       print $fifo "\n";
	  }
      $|--;
	}
    };
    $command{edit} = sub {
	my ($domain) = @_;
	my $file = "$keydir/$domain";
	if(-e $file){
	    system (@editor, $file);
	} else {
	    $command{new}->($domain);
	}
    };
    $command{new} = sub {
	my ($domain) = @_;
	my $filename = "$keydir/$domain";
	open (my $file, '|-', 'gpg', '--batch', '--no-tty', '-aer', 'cbancroft@bbn.com', '--output', $filename) or die "Failed to open $filename: $!";
	$|++;
	print $file "# Make sure that there are no extra submits, since it may trigger the wrong one.\n";
	printf $file "#%-10s | %-10s | %s\n", @fields;
	print $file "#------------------------------\n";
	my @data = `$downloader $url`;
	foreach my $line (@data){
	    if($line =~ m/<input ([^>].*?)>/i){
		$line =~ s/.*(<input ([^>].*?)>).*/$1/;
		printf $file " %-10s | %-10s | %s\n", map { my ($r) = $line =~ /.*$_=["'](.*?)["']/;$r } @fields;
    };
  };
  $|--;
};

$command{$cmd}->(domain($url));
