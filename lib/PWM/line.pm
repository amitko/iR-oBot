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
	# PERIOD in milliseconds
	# DUTY_MIN in milliseconds
	# DUTY_MAX in milliseconds
	# VALUE 1..1000 of the duty cycle
	# PIN ref to GPIO pin number
	# DEV ref to Device::BCM2835;

	print "NEW LINE with ".Dumper(\%Params);

    return undef unless $Params{'ID'} =~ /^\d+$/;
    return undef unless $Params{'PIN'};
    
    $Params{'PERIOD'} = 20 unless $Params{'PERIOD'};
    $Params{'DUTY_MIN'} = 1 unless $Params{'DUTY_MIN'};
    $Params{'DUTY_MAX'} = 2 unless $Params{'DUTY_MAX'};

    my $id = $Params{'ID'};

	my $dev = new  RasPI::dev;
	
    my $self = {
                'ID'        => $id,
                'DEV'       => $dev,
                'GPIO'      => $dev->gpio($Params{'PIN'}),
                'VALUE'     => 0,
                'PERIOD'    => $Params{'PERIOD'},
                'DUTY_MIN'  => $Params{'DUTY_MIN'},
                'DUTY_MAX'  => $Params{'DUTY_MAX'},
                'DUTY_SPAN' => ($Params{'DUTY_MAX'} - $Params{'DUTY_MIN'})*1000,
                };

    bless $self, $class;
    return $self;
}


sub duty_cycle {
    my $self = shift;
    
    my $hi = $self->{'DUTY_MIN'}*1000 - $self->{'DUTY_SPAN'}*$self->{'VALUE'}/1000; #in microseconds
    my $lo = $self->{'PERIOD'}*1000 - $hi; 

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
