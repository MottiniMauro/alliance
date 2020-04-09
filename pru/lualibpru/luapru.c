#include <stdio.h>
#include <string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include <sys/mman.h>

#include <prussdrv.h>
#include <pruss_intc_mapping.h>


#define PRU_NUM 0


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

struct PruSensors* shared_ram = NULL;

void load_device_tree_overlay()
{
    // Check if device tree overlay is loaded, load if needed.
    int device_tree_overlay_loaded = 0; 
    FILE* f;
    f = fopen("/sys/devices/bone_capemgr.9/slots","rt");
    if (f == NULL)
    {
        printf("Initialisation failed (fopen rt)");
        exit(1);
    }
    char line[256];
    while (fgets(line, 256, f) != NULL)
    {
        if(strstr(line, "PRU-DTO") != NULL)
        {
            device_tree_overlay_loaded = 1; 
        }
    }
    fclose(f);

    if (!device_tree_overlay_loaded)
    {
        f = fopen ("/sys/devices/bone_capemgr.9/slots","w");
        if(f==NULL)
        {
            printf ("Initialisation failed (fopen)");
            exit(1);
        }
        fprintf(f, "PRU-DTO");
        fclose(f);
        usleep(100000);
    }
}

static int wait_for_pru_event(lua_State *L)
{
    prussdrv_pru_wait_event(PRU_EVTOUT_0);
    prussdrv_pru_clear_event(PRU_EVTOUT_0, PRU0_ARM_INTERRUPT);

    lua_pushnumber(L, shared_ram->sensor_update_num);
    lua_pushnumber(L, shared_ram->sensor[shared_ram->sensor_update_num].value);

    return 2;
}

static int disable_pru(lua_State *L)
{
    prussdrv_pru_disable(PRU_NUM);
    prussdrv_exit ();

    return 0;
}

static int init_pru(lua_State *L)
{
    // Load device tree overlay to enable PRU hardware.
    load_device_tree_overlay();

    tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;
    prussdrv_init();
    prussdrv_open (PRU_EVTOUT_0);
    prussdrv_pruintc_init (&pruss_intc_initdata);

    // Get pointer to shared ram
    void* p;
    prussdrv_map_prumem (PRUSS0_SHARED_DATARAM, &p);
    shared_ram = (struct PruSensors *)p;

    shared_ram->num_sensors = 0;

    return 0;
}

static int add_sensor(lua_State *L)
{
	const char *type = luaL_checkstring (L, 1);
	unsigned int channel = lua_tonumber(L, 2);  

    if (!strcmp(type, "analog_threshold"))
    {
        shared_ram->sensor[shared_ram->num_sensors].type = ANALOG_THRESHOLD;

	    unsigned int threshold_high = lua_tonumber(L, 3);
	    unsigned int threshold_low = lua_tonumber(L, 4);

        shared_ram->sensor[shared_ram->num_sensors].threshold_high = threshold_high;
        shared_ram->sensor[shared_ram->num_sensors].threshold_low = threshold_low;
    }
    else if (!strcmp(type, "analog"))
    {
        shared_ram->sensor[shared_ram->num_sensors].type = ANALOG;
    }
    else
    {
        return 0;
    }
    

    shared_ram->sensor[shared_ram->num_sensors].channel = channel;

    shared_ram->sensor[shared_ram->num_sensors].value = 0;
    shared_ram->sensor[shared_ram->num_sensors].previous_value = -1;

    shared_ram->num_sensors++;

    return 0;
}

static int start_pru(lua_State *L)
{
    prussdrv_load_datafile (PRU_NUM, "./data.bin");

    prussdrv_exec_program_at (PRU_NUM, "./text.bin", 0);

    return 0;
}

static const struct luaL_reg luapru [] = {
		//core
        { "init_pru", init_pru },
        { "start_pru", start_pru },
        { "add_sensor", add_sensor },
        { "wait_for_pru_event", wait_for_pru_event },	
        { "disable_pru", disable_pru },		
		{ NULL, NULL } /* sentinel */
};


int luaopen_luapru(lua_State *L) 
{
	luaL_openlib(L, "luapru", luapru, 0);

	return 1;
}

