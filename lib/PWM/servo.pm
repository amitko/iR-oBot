package PWM::servo;
 
use Device::SMBus;
use Time::HiRes qw(usleep);

our %ADDR = (
 # Addresses
			'MODE1'         => 0x00,
  			'MODE2'         => 0x01,
	        'SUBADR1'       => 0x02,
            'SUBADR2'       => 0x03,
            'SUBADR3'       => 0x04,
            'PRESCALE'      => 0xFE,
            'LED0_ON_L'     => 0x06,
            'LED0_ON_H'     => 0x07,
            'LED0_OFF_L'    => 0x08,
            'LED0_OFF_H'    => 0x09,
            'ALL_LED_ON_L'  => 0xFA,
            'ALL_LED_ON_H'  => 0xFB,
            'ALL_LED_OFF_L' => 0xFC,
            'ALL_LED_OFF_H' => 0xFD,

  # Bits
            'RESTART'       => 0x80,
            'SLEEP'         => 0x10,
            'ALLCALL'       => 0x01,
            'INVRT'         => 0x10,
            'OUTDRV'        => 0x04,

			);

sub new {
    my $class = shift;

	my %opt = @_;

    my $self = {
    			'I2C' => Device::SMBus->new(
					     I2CBusDevicePath => $opt{'BusDevicePath'} || '/dev/i2c-1',
     					 I2CDeviceAddress => $opt{'DeviceAddress'} || 0x40,
   						),
                };



#	self.setAllPWM(0, 0)

	$self->{'I2C'}->writeByteData($ADDR{'ALL_LED_ON_L'}, 0 & 0xFF);
    $self->{'I2C'}->writeByteData($ADDR{'ALL_LED_ON_H'}, 0 >> 8);
    $self->{'I2C'}->writeByteData($ADDR{'ALL_LED_OFF_L'}, 0 & 0xFF);
    $self->{'I2C'}->writeByteData($ADDR{'ALL_LED_OFF_H'}, 0 >> 8);
# --- setAllPWM
    
    $self->{'I2C'}->writeByteData($ADDR{'MODE2'}, $ADDR{'OUTDRV'});
    $self->{'I2C'}->writeByteData($ADDR{'MODE1'}, $ADDR{'ALLCALL'});
    
    usleep(5);                                       # wait for oscillator
    
    my $mode1 = $self->{'I2C'}->readByteData($ADDR{'MODE1'});
    $mode1 = $mode1 & $ARRD{'SLEEP'};                 # wake up (reset sleep)
    $self->{'I2C'}->writeByteData($ADDR{'MODE1'}, $mode1);
    usleep(5);                             # wait for oscillator


    bless $self, $class;
    return $self;


}

sub setFrequency {
	my $self = shift;
	my $freq = shift;
	
	"Sets the PWM frequency"
    my $prescaleval = 25000000.0;    # 25MHz
    my $prescaleval /= 4096.0;       # 12-bit
    my $prescaleval /= freq;
    $prescaleval -= 1.0;
    $prescale = int($prescaleval + 0.5);

    my $oldmode = $self->{'I2C'}->readByteData($ADDR{MODE1});
    
    my $newmode = ($oldmode & 0x7F) | 0x10;             # sleep
    
    $self->{'I2C'}->writeByteData($ADDR{'MODE1'}, $newmode) # go to sleep
    $self->{'I2C'}->writeByteData($ADDR{'PRESCALE'}, int($prescale));
    $self->{'I2C'}->writeByteData($ADDR{'MODE1'}, $oldmode);
    usleep(5);
    $self->{'I2C'}->writeByteData($ADDR{'MODE1'}, $oldmode | 0x80);
}


sub setValue {
	my $self   = shift;
	my $chanel = shift;
	my $value  = shift;
	
	my $pulseLength = 1000000;                   # 1,000,000 us per second
    my $pulseLength /= 60;                       # 60 Hz
    my $pulseLength /= 4096;                     # 12 bits of resolution
  
  	my $value *= 1000;
    $value /= $pulseLength;
    $self->setPWM($chanel, 0, $pulse);
 	
}

sub setPWM {
	my $self   = shift;
	my $chanel = shift;
	my $on     = shift;
	my $off    = shift;
	
    $self->{'I2C'}->writeByteData($ADDR{'LED0_ON_L'}  + 4 * channel, $on & 0xFF);
    $self->{'I2C'}->writeByteData($ADDR{'LED0_ON_H'}  + 4 * channel, $on >> 8);
    $self->{'I2C'}->writeByteData($ADDR{'LED0_OFF_L'} + 4 * channel, $off & 0xFF);
    $self->{'I2C'}->writeByteData($ADDR{'LED0_OFF_H'} + 4 * channel, $off >> 8);
	
}

sub setAllPWM
	my $self   = shift;
	my $chanel = shift;
	my $on     = shift;
	my $off    = shift;

#    $self->{'I2C'}->writeByteData(self.__ALL_LED_ON_L, on & 0xFF)
#    self.i2c.write8(self.__ALL_LED_ON_H, on >> 8)
#    self.i2c.write8(self.__ALL_LED_OFF_L, off & 0xFF)
#    self.i2c.write8(self.__ALL_LED_OFF_H, off >> 8)
 
1;