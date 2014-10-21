#include "SocketUdp.h"

#include <sstream>
#include <iostream>
#include <chrono>

using namespace toroco;
using namespace std::chrono;

int main()
{
    unsigned long long total_time = 0;
    SocketUDP socket;
    
    socket.Create();
    
    if (socket.Connect("192.168.7.2", 2113))
    {
        std::cout << "Sending!" << std::endl;

        // index from 0 to 999
        int index = 0;

        while (true)
        {

            std::stringstream ss;

            ss << "hello" << "," << system_clock::now().time_since_epoch().count() << std::endl;
            
            if (total_time == 0)
                total_time = system_clock::now().time_since_epoch().count();

            socket.Send(ss.str());

            // update index

            index++;

            if (index == 1000) 
            {
                total_time = system_clock::now().time_since_epoch().count() - total_time;

                sleep (1);

                ss.str(std::string());

                ss << "end" << "," << index << std::endl;
    
                socket.Send(ss.str());

                std::cout << "Sent: " << index << " packets."<< std::endl;
                std::cout << "Total sending time: " << total_time << " us." << std::endl;

                break;
            }
            else 
            {
                usleep (10000);
            }
        }

        socket.Close();
    }

	return 0;
}
