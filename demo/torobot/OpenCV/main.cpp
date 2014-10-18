#include "ColorDetect.h"
#include "SocketUdp.h"

#include <sstream>
#include <iostream>

using namespace toroco;

int main()
{
	ColorDetect cd;
    cv::Point2f center;

	cv::namedWindow("Color Detect");

    SocketUDP socket;
    
    socket.Create();
    
    if (socket.Connect("localhost", 2113))
    {
        while (true)
        {

		    center = cd.detect();

            std::stringstream ss;
            ss << center.x << "," << center.y << std::endl;

            socket.Send(ss.str());

		    if (cv::waitKey(45) >= 0) 
                break;
        }

        socket.Close();
    }

	return 0;
}
