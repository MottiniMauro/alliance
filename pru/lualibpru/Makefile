PRU_COMPILER_DIR=/usr/share/ti/cgt-pru
PRU_C_FLAGS=--silicon_version=2 --hardware_mac=on -i$(PRU_COMPILER_DIR)/include -i$(PRU_COMPILER_DIR)/lib 
PRU_LD_FLAGS=-llibc.a

LUA_SRC = ../lua-5.1.4/src/

HOST_C_FLAGS += -Wall -fPIC -I/usr/local/include -I$(LUA_SRC) 
HOST_LD_FLAGS += -lpthread -shared -soname luapru.so.1

FIND_ADDRESS_COMMAND=`dispru pru.elf | grep _c_int00 | cut -f1 -d\  `

.PHONY: all
all:
	# Compile pru.c into pro.obj
	clpru $(PRU_C_FLAGS) -c pru.c

	# Link pru.obj with libraries and output pru.map and pru.elf
	clpru $(PRU_C_FLAGS) -z pru.obj $(PRU_LD_FLAGS) \
		-m pru.map -o pru.elf AM3359_PRU.cmd

	# Convert pru.elf into text.bin and data.bin
	hexpru bin.cmd ./pru.elf

	# Find address of start of program and compile host program
	$(CC) $(HOST_C_FLAGS) -o luapru.o -c luapru.c
	$(LD) $(HOST_LD_FLAGS) -o luapru.so luapru.o /usr/local/lib/libprussdrv.so

.PHONY: clean
clean:
	-rm *.obj
	-rm *.map
	-rm *.elf
	-rm *.bin
	-rm *.o
	-rm *.so
