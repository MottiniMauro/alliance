#include "ColorDetect.h"
#include "SocketUdp.h"

#include <sstream>
#include <iostream>

using namespace toroco;

int main()
{
	ColorDetect cd;
    cv::Point2i color_center;

	cv::namedWindow("Color Detect");

    SocketUDP socket;
    
    socket.Create();
    
    if (socket.Connect("localhost", 2113))
    {
        while (true)
        {
            // get blob center
		    color_center = cd.detect();

            std::stringstream ss;

            if (color_center.x >= -100 and color_center.x <= 100) {
                ss << color_center.x << "," << color_center.y << std::endl;
            }
            else {
                ss << "none" << std::endl;
            }
    
            socket.Send(ss.str());

		    if (cv::waitKey(45) >= 0) 
                break;
        }

        socket.Close();
    }

	return 0;
}
