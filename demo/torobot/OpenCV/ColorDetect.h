#ifndef COLORDETECT_H
#define COLORDETECT_H

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/video/video.hpp>
#include <memory>
#include <vector>
#include <string>
#include <iostream>

class ColorDetect
{
	cv::VideoCapture vcap;
	std::unique_ptr< cv::VideoWriter > writer2; 

public:
	ColorDetect();
	~ColorDetect();
	void getVideo();
	cv::Mat getThresh(const cv::Mat &inImg);
	cv::Point2i detect();
};

#endif
