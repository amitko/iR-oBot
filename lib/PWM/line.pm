package PWM::line;

use strict;
use Data::Dumper;
use IPC::Shareable;
use RasPI::dev;
use RasPI::gpio;

sub new {
    my $class = shift;

	my %Params = @_;

	# ID
	# PERIOD in microseconds
	# DUTY_MIN in microseconds
	# DUTY_MAX in microseconds
	# VALUE 1..1000 of the duty cycle
	# PIN ref to GPIO pin number
	# DEV ref to Device::BCM2835;

	print "NEW LINE with ".Dumper(\%Params);

    return undef unless $Params{'ID'} =~ /^\d+$/;
    return undef unless $Params{'PIN'};

    my $period;
    my $duty_min;
    my $duty_max;

    if ( uc $Params{'TYPE'} eq 'SERVO') {
        $period   = $Params{'PERIOD'}   || 20000;
        $duty_min = $Params{'DUTY_MIN'} || 1000;
        $duty_max = $Params{'DUTY_MAX'} || 2000;
    }
    elsif (uc $Params{'TYPE'} eq 'MOTOR') {
        $period   = $Params{'PERIOD'}   || 200;
        $duty_min = $Params{'DUTY_MIN'} || 0;
        $duty_max = $Params{'DUTY_MAX'} || 200;
    }
    else {
        $period   = $Params{'PERIOD'}   || 100;
        $duty_min = $Params{'DUTY_MIN'} || 0;
        $duty_max = $Params{'DUTY_MAX'} || 50;
    }

    my $id = $Params{'ID'};

	my $dev = new RasPI::dev;

    my $self = {
                'ID'        => $id,
                'DEV'       => $dev,
                'GPIO'      => $dev->gpio($Params{'PIN'}),
                'VALUE'     => 0,
                'PERIOD'    => $period,
                'DUTY_MIN'  => $duty_min,
                'DUTY_MAX'  => $duty_max,
                'DUTY_SPAN' => ($duty_max - $duty_min),
                };

    bless $self, $class;
    return $self;
}


sub duty_cycle {
    my $self = shift;

    my $hi = $self->{'DUTY_MIN'} + $self->{'DUTY_SPAN'}*$self->{'VALUE'}/1000; #in microseconds
    my $lo = $self->{'PERIOD'} - $hi;

    $self->{'GPIO'}->up($hi,'MICRO' => 1);
	$self->{'GPIO'}->dn($lo,'MICRO' => 1);
}



sub stop {
	my $self = shift;
	$self->{'GPIO'}->dn();
	delete $self->{'ID'};
}

sub value {
	my $self = shift;
	my $value = shift;
	$self->{'VALUE'} = $value if defined $value;
	return $self->{'VALUE'};
}

1;
