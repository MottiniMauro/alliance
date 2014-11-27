#include "ColorDetect.h"
#include "SocketUdp.h"

#include <sstream>
#include <iostream>

using namespace toroco;

int main()
{
	ColorDetect cd;
    cv::Point2i color_center;
    int color = 0;

	cv::namedWindow("Color Detect");

    SocketUDP socket;
    
    socket.Create();
    
    if (socket.Connect("localhost", 2113))
    {
        while (true)
        {
        	// change color
            color = 1 - color;
            
            // get blob center
		    color_center = cd.detect (color);

			// write message
            std::stringstream ss;
            
            if (color == 1) {
            	ss << "red,";
            }
            else {
            	ss << "trq,";
            }
            
			//std::cout << color_center.x << "x " << color_center.y << "y" << std::endl;

            if (color_center.x >= -100 and color_center.x <= 100) {
                ss << color_center.x << "," << color_center.y << std::endl;
            }
            else {
                ss << -999 << "," << -999 << std::endl;
            }
    
    		// send message
            socket.Send(ss.str());

		    if (cv::waitKey(1) >= 0) 
                break;
        }

        socket.Close();
    }

	return 0;
}
