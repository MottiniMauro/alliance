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
    
    if (socket.Connect("192.168.7.2", 2120))
    {
        std::cout << "Sending!" << std::endl;

        // index from 0 to 999
        int index = 0;

        while (true)
        {

            std::stringstream ss;

			// add packet index and current system time time the stream.
            ss << index << "," << system_clock::now().time_since_epoch().count() << std::endl;
            
            // start total sending time
            if (total_time == 0)
                total_time = system_clock::now().time_since_epoch().count();
			
			// send stream to the socket
            socket.Send(ss.str());

            // update index

            index++;

            if (index == 1000) 
            {
            	// get total sending time
                total_time = system_clock::now().time_since_epoch().count() - total_time;

                sleep (1);

                ss.str(std::string());

				// add end commant to the socket.
                ss << "end" << "," << index << std::endl;
    
				// send stream to the socket
                socket.Send(ss.str());

				// print results
                std::cout << "Sent: " << index << " packets."<< std::endl;
                std::cout << "Total sending time: " << total_time << " us." << std::endl;

                break;
            }
            else 
            {
            	// 10 ms works fine
                usleep (1000);
            }
        }

        socket.Close();
    }

	return 0;
}
