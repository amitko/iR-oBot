package PWM::Services;

use Data::Dumper;

sub new {
	my $class = shift;
	
	 my $self = {
                'LINES_AVAILABLE'  => [],
                'LINES'            => {},
                'START'            => 0,
                'STOP'             => 0,
                'PROCESSES'        => [],
                };
	
	bless $self, $class;
    return $self;
    
}

sub add_line {
	my $self = shift;
	my $line = shift;
	
	push @{$self->{'LINES'}}, $line;
			
}

sub start {
	$self = shift;
	$self->{'START'} = time();
	$self->{'STOP' } = 0;

	for my $l (@$self->{'LINES_AVAILABLE'}) {

		$self->{'LINES'}{$l->{'ID'}} = tie $l, 'IPC::Shareable', "PWM_".$l->{'ID'}, { destroy => 1 };
	
		unless ( $child = fork() ) {        # the child
    	    die "cannot fork: $!" unless defined $child;
        	$l->run();
        	exit;
    	} 
	}
}

sub valueForID {
	my $self = shift;
	my $id   = shift;
	my $value = shift;
	$self->{'LINES'}{'ID'}{'VALUE'} = $value;   
}

sub stop {
	$self = shift;
	$self->{'START'} = 0;
	$self->{'STOP' } = time();
}


1;