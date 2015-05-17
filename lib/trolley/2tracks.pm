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

	my $left_line_forward = new PWM::line (
								'ID'       => 1,
<<<<<<< HEAD
								'PIN'      => $opt{'LEFT_PIN_F'},
								'PERIOD'   => 100,
								'DUTY_MIN' => 0,
								'DUTY_MAX' => 100,
=======
								'PIN'      => $opt{'LEFT_PIN'},
								'TYPE'     => 'MOTOR'
>>>>>>> 2b274fda64fa88e98b64cdf1bfd286505f1fdd54
								);

	my $left_line_revese = new PWM::line (
								'ID'       => 2,
<<<<<<< HEAD
								'PIN'      => $opt{'LEFT_PIN_R'},
								'PERIOD'   => 100,
								'DUTY_MIN' => 0,
								'DUTY_MAX' => 100,
								);

	my $right_line_forward = new PWM::line (
								'ID'       => 3,
								'PIN'      => $opt{'RIGHT_PIN_F'},
								'PERIOD'   => 100,
								'DUTY_MIN' => 0,
								'DUTY_MAX' => 100,
								);
	my $right_line_revers = new PWM::line (
								'ID'       => 4,
								'PIN'      => $opt{'RIGHT_PIN_R'},
								'PERIOD'   => 100,
								'DUTY_MIN' => 0,
								'DUTY_MAX' => 100,
								);

	
=======
								'PIN'      => $opt{'RIGHT_PIN'},
								'TYPE'     => 'MOTOR'
								);


	my $s = new PWM::Service ('WITH_LINES' => [$left_line, $right_line])

>>>>>>> 2b274fda64fa88e98b64cdf1bfd286505f1fdd54

	my $s = new PWM::Service ('WITH_LINES' => [$left_line_forward, $left_line_referse, $right_line_forward, $right_line_reverse])
	


	my $left = new trolley::track (
								'LINE_FORWARD' => $left_line_forward,
								'LINE_REVERSE' => $left_line_reverse,
								);

	my $right = new trolley::track (
								'LINE_FORWARD' => $right_line_forward,
								'LINE_REVERSE' => $right_line_reverse,
								);


	my $self = {
				'SERVICE' => $s,
				'DEVICE'  => $d,
				'LEFT'    => $left,
				'RIGHT'   => $right,
				}


	bless $self, $class;
    return $self;

}


sub forward {
	my $self = shift;
	my $power = shift || 0;
<<<<<<< HEAD
	
	$self->{'LEFT'}->power( $power );
	$self->{'RIGHT'}->power( $power );
	
=======

	$self->{'LEFT'}->forward( $power );
	$self->{'RIGHT'}->forward( $power );

>>>>>>> 2b274fda64fa88e98b64cdf1bfd286505f1fdd54
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
