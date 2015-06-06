#!/usr/bin/perl

use strict;
use lib 'lib';

use PWM::Service;
use PWM::line;

use Data::Dumper;

my $l1 = new PWM::line ( ID   => '1', 
						 TYPE => 'SERVO', 
						 PIN  => ,
						 );

print Dumper($l1);
die "New Line failed\n\n" unless $l;

my $s = new PWM::Service ('WITH_LINES' => [$l1]);

$s->start();

while ( 2 ) {

	my $angle = 5 - int(rand(10));
	print "change to angle $angle\n";

	$s->valueForID('1', 500 + (100 * $angle) );	
	print "changed\n\n";
	
	sleep(3);
}
