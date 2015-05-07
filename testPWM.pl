#!/usr/bin/perl

use strict;
use lib 'lib';

use PWM::Service;
use PWM::line;

use Data::Dumper;

my $l1 = new PWM::line ( ID => '1');
my $l2 = new PWM::line ( ID => '2');

print Dumper($l1,$l2);

my $s = new PWM::Service ('WITH_LINES' => [$l1, $l2]);

$s->start();
sleep(5);
$s->valueForID('1', 10);
sleep(3);
$s->valueForID('2', 20);
sleep(10);

print Dumper($s);
