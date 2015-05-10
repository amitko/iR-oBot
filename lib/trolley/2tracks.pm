package trolley::2tracks;

use strict;

use RasPI::gpio;
use RasPI::dev;

use PWM::Service;
use PWM::line;

use trolley::track;

use Data::Dumper;

sub new {
	my $class = shift;
	my %opt = @_;
	
	# LEFT_PIN
	# RIGHT_PIN
	# PIN_REVERSE_LEFT
	# PIN_REVERSE_RIGHT

	my $left_line = new PWM::line (
								'ID'       => 1,
								'PIN'      => $opt{'LEFT_PIN'},
								'PERIOD'   => 100,
								'DUTY_MIN' => 0,
								'DUTY_MAX' => 100,
								);

	my $right_line = new PWM::line (
								'ID'       => 2,
								'PIN'      => $opt{'RIGHT_PIN'},
								'PERIOD'   => 100,
								'DUTY_MIN' => 0,
								'DUTY_MAX' => 100,
								);
	

	my $s = new PWM::Service ('WITH_LINES' => [$left_line, $right_line])
	

	my $d = new  RasPI::dev;
	my $left_r = $d->gpio($opt{'PIN_REVERSE_LEFT'});
	my $right_r = $d->gpio($opt{'PIN_REVERSE_RIGHT'});

	
	my $left = new trolley::track (
								'LINE' => $left_line,
								'LINE_ID' => 1,
								'REVERSE' => $left_r,
								);

	my $left = new trolley::track (
								'SERVICE' => $right_line,
								'LINE_ID' => 2,
								'REVERSE' => $right_r,
								);

	
	my $self = {
				'SERVICE' => $s,
				'DEVICE'  => $d,
				'LEFT'    => $left,
				'RIGHT'   => $right,
				'LEFT_R'  =>  $left_r,
				'RIGHT_R' =>  $right_r,
				}
				
				
	bless $self, $class;
    return $self;				
	
}


sub forward {
	my $self = shift;
	my $power = shift || 0;
	
	$self->{'LEFT'}->forward( $power );
	$self->{'RIGHT'}->forward( $power );
	
}

sub reverse {
	my $self = shift;
	my $power = shift || 0;
	
	$self->{'LEFT'}->power( -$power );
	$self->{'RIGHT'}->power( -$power );
	
}

sub turn_left_with_reverse {
	my $self = shift;
	my $power = shift || 0;
	
	$self->{'LEFT'}->power( -$power );
	$self->{'RIGHT'}->power( $power );	
}

sub turn_right_with_reverse {
	my $self = shift;
	my $power = shift || 0;
	
	$self->{'LEFT'}->power( $power );
	$self->{'RIGHT'}->power( -$power );	
}

sub turn_left {
	my $self = shift;
	my $power = shift || 0;
	
	$self->{'LEFT'}->power( $self->{'LEFT'}{'POWER'} - $power, 'CORRECTION' => 1 );
	$self->{'RIGHT'}->power( $self->{'RIGHT'}{'POWER'} + $power, 'CORRECTION' => 1 );	
}

sub turn_right {
	my $self = shift;
	my $power = shift || 0;
	
	$self->{'LEFT'}->power( $self->{'LEFT'}{'POWER'} + $power,'CORRECTION' => 1 );
	$self->{'RIGHT'}->power( $self->{'RIGHT'}{'POWER'} - $power,'CORRECTION' => 1 );	
}


1;