package PWM::line;

use strict;
use Data::Dumper;
use IPC::Shareable;


sub new {
    my $class = shift;

	my %Params = @_;

	# ID
	# PERIOD in milliseconds
	# DUTY_MIN in milliseconds
	# DUTY_MAX in milliseconds
	# VALUE 1..1000 of the duty cycle
	# GPIO ref to GPIO object

	print "NEW LINE with ".Dumper(\%Params);

    return undef unless $Params{'ID'} =~ /^\d+$/;
    $Params{'PERIOD'} = 20 unless $Params{'PERIOD'};
    $Params{'DUTY_MIN'} = 1 unless $Params{'DUTY_MIN'};
    $Params{'DUTY_MAX'} = 2 unless $Params{'DUTY_MAX'};

    my $id = $Params{'ID'};
#    $Params{'GPIO'} = new RasPI::gpio

    my $self = {
                'ID'       => $id,
                'GPIO'     => undef,
                'VALUE'    => 0,
                'PERIOD'   => $Params{'PERIOD'},
                'DUTY_MIN' => $Params{'DUTY_MIN'},
                'DUTY_MAX' => $Params{'DUTY_MAX'},
                };

    bless $self, $class;
    return $self;
}


sub duty_cycle {
    my $self = shift;
    sleep(1);
}

sub stop {
	my $self = shift;
	delete $self->{'ID'};
}

1;
