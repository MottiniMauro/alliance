/////////////////////////////////////////////////////////////////////
// UTIL
//
#define HWREG(x) (*((volatile unsigned int *)(x)))
#define min(a,b) (a<b ? a : b)

/////////////////////////////////////////////////////////////////////
// GLOBALS
//

void init_sensors();
void init_adc();

volatile register unsigned int __R31;
int finish = 0;

enum SensorType
{
    ANALOG,
    ANALOG_THRESHOLD,
    DIGITAL
};

struct Sensor
{
    unsigned int type;
    union {
        unsigned int input_num;
        unsigned int channel;
    };

    unsigned int threshold_high;
    unsigned int threshold_low;

    unsigned int value;
    unsigned int previous_value;

    unsigned int step;
};

struct PruSensors 
{
    unsigned int num_sensors;
    struct Sensor sensor[5];
    unsigned int sensor_update_num;
};

volatile struct PruSensors* shared_ram;

unsigned int read_sensor (unsigned int sensor_num, unsigned int* data)
{
    unsigned int i, fifo0_count, read = 0, buffer, step;

    // Enable step. STEPENABLE register
    HWREG(0x44e0d054) = 1 << (shared_ram->sensor[sensor_num].step + 1);
    
    fifo0_count = HWREG(0x44e0d0e4);
    for (i = 0; i < fifo0_count; i++)
    {
        buffer = HWREG(0x44e0d100);
        step = (buffer & 0xf0000) >> 16;
        if (step == shared_ram->sensor[sensor_num].step)
        {
            *data = buffer & 0xfff;
            read = 1;
        }
    }

    return read;
}

int main(int argc, const char *argv[])
{
    unsigned int i;

    unsigned int data = 0;

    shared_ram = (volatile struct PruSensors *)0x10000;

    init_adc();


    while (!finish)
    {
        for (i = 0; i < shared_ram->num_sensors; i++)
        {
            switch (shared_ram->sensor[i].type)
            {
                case ANALOG:

                    if (!read_sensor(i, &(shared_ram->sensor[i].value)))
                        break;

                    shared_ram->sensor[i].value = shared_ram->sensor[i].value;

                        shared_ram->sensor_update_num = i;
                        //shared_ram->sensor[i].previous_value = shared_ram->sensor[i].value;
                        __R31 = 35;
                    
                    break;

                case ANALOG_THRESHOLD:

                    if (!read_sensor(i, &data))
                        break;

                    if (data > shared_ram->sensor[i].threshold_high)
                    {
                        shared_ram->sensor[i].value = 1;
                    }
                    else if (data < shared_ram->sensor[i].threshold_low)
                    {
                        shared_ram->sensor[i].value = 0;
                    }

                    if (shared_ram->sensor[i].value != shared_ram->sensor[i].previous_value)
                    {
                        shared_ram->sensor_update_num = i;
                        shared_ram->sensor[i].previous_value = shared_ram->sensor[i].value;
                        __R31 = 35;
                    }

                    break;
            }
        }
    }

    // stop pru processing
    __halt(); 

    return 0;
}

void init_adc(){
    // Enable OCP so we can access the whole memory map for the
    // device from the PRU. Clear bit 4 of SYSCFG register
    HWREG(0x26004) &= 0xFFFFFFEF;

    // Enable clock for adc module. CM_WKUP_ADC_TSK_CLKCTL register
    HWREG(0x44e004bc) = 0x02;

    // Disable ADC module temporarily. ADC_CTRL register
    HWREG(0x44e0d040) &= ~(0x01);

    HWREG(0x44e0d040) &= ~(0x01 << 7);

    // To calculate sample rate:
    // fs = 24MHz / (CLK_DIV*2*Channels*(OpenDly+Average*(14+SampleDly)))
    // We want 48KHz. (Compromising to 50KHz)
    unsigned int clock_divider = 4;
    unsigned int open_delay = 4;
    unsigned int average = 4;       // can be 0 (no average), 1 (2 samples), 
                                    // 2 (4 samples),  3 (8 samples) 
                                    // or 4 (16 samples)
    unsigned int sample_delay = 4;

    // Set clock divider (set register to desired value minus one). 
    // ADC_CLKDIV register
    HWREG(0x44e0d04c) = clock_divider - 1;

    // Set values range from 0 to FFFF. ADCRANGE register
    HWREG(0x44e0d048) = (0xffff << 16) & (0x000);

    // Disable all steps. STEPENABLE register
    HWREG(0x44e0d054) &= ~(0x1ffff);

    // Unlock step config register. ACD_CTRL register
    HWREG(0x44e0d040) |= (0x01 << 2);

    unsigned int step = 0, channel, i;
    for (i = 0; i < shared_ram->num_sensors; i++)
    {
        if (shared_ram->sensor[i].type == ANALOG || shared_ram->sensor[i].type == ANALOG_THRESHOLD)
        {           
            channel = shared_ram->sensor[i].channel;

            // Set config for step. sw mode, continuous mode, 
            // use fifo0. STEPCONFIG1 register
            HWREG(0x44e0d064 + i*8) = 0x0000 | (0x0<<26) | (channel<<19) | (channel<<15) | (average<<2) | (0x00);
            HWREG(0x44e0d068 + i*8) = 0x0000 | (sample_delay - 1)<<24 | open_delay;

            // Enable step. STEPENABLE register
            //HWREG(0x44e0d054) |= 1 << (step + 1);
            shared_ram->sensor[i].step = step;

            step++;
        }
    }

    // Lock step config register. ACD_CTRL register
    HWREG(0x44e0d040) &= ~(0x01 << 2);

    // Clear FIFO0 by reading from it. FIFO0COUNT, FIFO0DATA registers
    unsigned int count = HWREG(0x44e0d0e4);
    unsigned int data;
    for(i=0; i<count; i++){
        data = HWREG(0x44e0d100);
    }

    // Clear FIFO1 by reading from it. FIFO1COUNT, FIFO1DATA registers
    count = HWREG(0x44e0d0f0);
    for (i=0; i<count; i++){
        data = HWREG(0x44e0d200);
    }
    //shared_ram[500] = data; // just remove unused value warning;

    // Enable tag channel id. ADC_CTRL register
    HWREG(0x44e0d040) |= 0x02;

    

    // Enable Module (start sampling). ADC_CTRL register
    HWREG(0x44e0d040) |= 0x01;
}
