#include "SocketUdp.h"

#include <sstream>
#include <iostream>
#include <chrono>

using namespace toroco;
using namespace std::chrono;

int main()
{
    unsigned long long received_time, time, max_time = 0, min_time = 0, total_time = 0, sum_time = 0;
    SocketUDP socket;
    
    socket.Create();
    
    if (socket.Bind(2113))
    {        
        char msg[100];
        int count = 0;
        while (true)
        {
            socket.Recv(msg, 100);

            std::istringstream ss(msg);
            std::string cmd;

            std::getline(ss, cmd, ',');

            if (cmd == "end") 
            {
                total_time = received_time - total_time;
                unsigned int sent_count;
                ss >> sent_count;

                std::cout << "Sent: " << sent_count << " Received: " << count << std::endl;
                std::cout << "Max latency time: " << max_time << " us." << std::endl;
                std::cout << "Avg latency time: " << sum_time / count << " us." << std::endl;
                std::cout << "Min latency time: " << min_time << " us." << std::endl;
                std::cout << "Total receiving time: " << total_time << " us." << std::endl;
                break;
            }
            else
            {
                received_time = system_clock::now().time_since_epoch().count();

                ss >> time;
                
                time = received_time - time;
                sum_time += time;

                if (total_time == 0)
                    total_time = received_time;

                if (time > max_time)
                    max_time = time;

                if (time < min_time || min_time == 0)
                    min_time = time;

                count++;
            }
        }

        socket.Close();
    }

	return 0;
}
