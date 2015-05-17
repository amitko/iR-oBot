package trolley::track;

use strict;
use PWM::Service;

use RasPI::gpio;

use Data::Dumper;

sub new {
	my $class = shift;
	my %opt = @_;
	
	my $self = {
				'LINE_FORWARD'  => $opt{'LINE_FORWARD'},    # PWM::line
				'LINE_REVERSE'  => $opt{'LINE_REVERSE'},    # PWM::line
				'POWER'         => 0,
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
		$self->{'LINE_REVERSE'}->value(0);
		$self->{'LINE_FORWARD'}->value(0);
		$self->{'LINE_REVERSE'}->value($power);
	}
	else {
		$self->{'LINE_REVERSE'}->value(0);
		$self->{'LINE_FORWARD'}->value(0);
		$self->{'LINE_FORWARD'}->value($power);
	}

	$self->{'POWER'} = $power unless $opt{'CORRECTION'};
	
}

1;