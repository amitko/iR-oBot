package PWM::Service;

use strict;
use Data::Dumper;
use IPC::Shareable;

sub new {
	my $class = shift;
	my %P = @_;

    print 'NEW SERVICE with '.Dumper(\%P);

	 my $self = {
                'LINES_AVAILABLE'  => [],
                'LINES'            => {},
                'START'            => 0,
                'STOP'             => 0,
                'PROCESSES'        => [],
                };

	bless $self, $class;

    if ( exists $P{'WITH_LINES'} ) {
        $self->{'LINES_AVAILABLE'} = $P{'WITH_LINES'};
    }
    return $self;

}

sub add_line {
	my $self = shift;
	my $line = shift;

	push @{$self->{'LINES_AVAILABLE'}}, $line;

}

sub start {
	my $self = shift;
	$self->{'START'} = time();
	$self->{'STOP' } = 0;


	for my $l (@{$self->{'LINES_AVAILABLE'}}) {


        my $L;
		my $h = tie $L, 'IPC::Shareable', $l->{'ID'}, { %{$self->tie_options} } or die "tie failed\n";

        $L = $l;

        $self->{'LINES'}{ $l->{'ID'} } = {
                                        H => $h,
                                        L => $l,
                                        };

    	unless ( my $child = fork() ) {        # the child
    	    die "cannot fork: $!" unless defined $child;
        	$self->run_line( $l->{'ID'} );
        	exit;
    	}
	}
}

sub valueForID {
	my $self = shift;
	my $id   = shift;
	my $value = shift;

    my $line;
	my $h = tie $line, 'IPC::Shareable', $id, { %{$self->tie_options} } or die "tie failed\n";

print "CHANGE VALUE FOR ID $id from ".$line->{'VALUE'}." TO (".$value.")\n";

	$line->{'VALUE'} = $value;

}

sub run_line {
    my $self = shift;
    my $id = shift;

	my %options = (
         create    => 0,
         exclusive => 0,
         mode      => 0644,
         destroy   => 0,
        );

    my $line;

    tie $line, 'IPC::Shareable', $id, { %options } or die "tie failed\n";

    print Dumper($line);

	while (1) {
        exit unless $line and exists $line->{'ID'};
print "RUNNING [".$line->{'ID'}."] VALUE (".$line->{'VALUE'}.") \n\n";
		$line->duty_cycle();
	}
}


sub stop {
	my $self = shift;
	$self->{'START'} = 0;
	$self->{'STOP' } = time();
}

sub tie_options {
    my $self = shift;

    return 	{
        create    => 'yes',
        exclusive => 0,
        mode      => 0644,
        destroy   => 'yes',
        };

}

1;
