package trolley::track;

use strict;
use PWM::Service;

use RasPI::gpio;

use Data::Dumper;

sub new {
	my $class = shift;
	my %opt = @_;
	
	my $self = {
				'LINE'     => $opt{'LINE'},    # PWM::line
				'REVERSE'  => $opt{'REVERSE'}, # RasPI::gpio
				'POWER'    => 0,
				};
	
	bless $self, $class;
    return $self;
}


sub power {
	my $self = shift;
	my $power = shift;
	my %opt = @_;

	return $self->{'POWER'} unless exists $power;		
		
	if ( $power < 0 ) {
		$self->{'REVERSE'}->up();
	}
	else {
		$self->{'REVERSE'}->dn();
	}

	$self->{'POWER'} = $power unless $opt{'CORRECTION'};
	$power = abs ($power);
	
	$self->{'LINE'}->value($power);
}

1;