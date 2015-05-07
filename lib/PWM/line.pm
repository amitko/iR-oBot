package PWM::line;

use Data::Dumper;

sub new {
    my $class = shift;
	
	my %Params = @_;

	# ID
	# PERIOD in milliseconds
	# DUTY_MIN in milliseconds
	# DUTY_MAX in milliseconds
	# VALUE 1..1000 of the duty cycle	
	# GPIO ref to GPIO object
	
    return undef unless $Params{'ID'};
    $Params{'PERIOD'} = 20 unless $Params{'PERIOD'};
    $Params{'DUTY_MIN'} = 1 unless $Params{'DUTY_MIN'};
    $Params{'DUTY_MAX'} = 2 unless $Params{'DUTY_MAX'};

    $Params{'ID'} =~ /(\d\d)$/;
    my $id = $1;
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

sub run {
	my $self = shift;
	while (1) {
		print "RUNNING ".$self->{'ID'}." VALUE ".$self->{'VALUE'}."\n\n";
		sleep(3);
	}
}

sub stop {
	my $self = shift;
	print "STOP ".$self->{'ID'}."\n\n";
}

1;