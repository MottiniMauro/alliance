#include "ColorDetect.h"

ColorDetect::ColorDetect()
{

	writer2 = std::unique_ptr< cv::VideoWriter > (new cv::VideoWriter("output.avi", CV_FOURCC('D', 'I', 'V', 'X'), 5, cv::Size(640, 480), true));
	getVideo();
}

ColorDetect::~ColorDetect() { }

void ColorDetect::getVideo()
{
	vcap.open(0); //0 = connected webcam
	
	if (!vcap.isOpened())
		std::cout << "Could not open video input stream" << std::endl;
	if (!writer2->isOpened())
		std::cout << "Could not open video output stream" << std::endl;
	
}

// convert image pixels to white if they are in range, and black if they are out of range.

cv::Mat ColorDetect::getThresh(const cv::Mat &inImg)
{
	cv::Mat tmpImg = inImg;
	cv::Mat imgThresh(tmpImg.size(), tmpImg.type());
	
	cv::inRange(tmpImg, cv::Scalar(0, 60, 60), cv::Scalar(20, 200, 255), imgThresh);
	
	return imgThresh;
}


// *** color filters ***

// 8 bit palette

void colorFilter_8Bit (cv::Mat &cvtImg) {
	
	int width = cvtImg.cols;
	int height = cvtImg.rows;
	
	for( int indx = 0; indx < height; indx++ ) {
		for( int indy = 0; indy < width; indy++ ) {
		
			cvtImg.at<cv::Vec3b>(indx,indy)[0] = (cvtImg.at<cv::Vec3b>(indx,indy)[0] / 8) * 8;
			cvtImg.at<cv::Vec3b>(indx,indy)[1] = (cvtImg.at<cv::Vec3b>(indx,indy)[1] / 32) * 32;
			cvtImg.at<cv::Vec3b>(indx,indy)[2] = (cvtImg.at<cv::Vec3b>(indx,indy)[2] / 32) * 32;
		}
	}
}

// super saturate

void colorFilter_Saturate (cv::Mat &cvtImg) {
	
	int width = cvtImg.cols;
	int height = cvtImg.rows;
	
	for( int indx = 0; indx < height; indx++ ) {
		for( int indy = 0; indy < width; indy++ ) {
		
			cvtImg.at<cv::Vec3b>(indx,indy)[2] = cvtImg.at<cv::Vec3b>(indx,indy)[2] * 1.6;
			if (cvtImg.at<cv::Vec3b>(indx,indy)[2] > 180) {
				cvtImg.at<cv::Vec3b>(indx,indy)[2] = 180;
			}
		}
	}
}

// grey and red

void colorFilter_Red (cv::Mat &cvtImg) {
	
	int width = cvtImg.cols;
	int height = cvtImg.rows;
	
	for( int indx = 0; indx < height; indx++ ) {
		for( int indy = 0; indy < width; indy++ ) {
		
			int lightness = cvtImg.at<cv::Vec3b>(indx,indy)[1];
			int saturation = cvtImg.at<cv::Vec3b>(indx,indy)[2];
			
			cvtImg.at<cv::Vec3b>(indx,indy)[0] = (cvtImg.at<cv::Vec3b>(indx,indy)[0] + 10) % 180;
			
			// remove non-red
			if (cvtImg.at<cv::Vec3b>(indx,indy)[0] > 12) {
				saturation = 0;
			}
			
			// aplly other filters
			else {
				cvtImg.at<cv::Vec3b>(indx,indy)[0] = cvtImg.at<cv::Vec3b>(indx,indy)[0] / 2;
				
				// remove black
				if (lightness < 60) {
					saturation = 0;
				}
			
				// remove grey
				if (saturation < 90) {
					saturation = 0;
				}
			
				// remove white
				if (lightness > 150) {
					saturation = 0;
				}
			
				// remove skin
				if ((saturation < 110) && (lightness > 130)) {
					saturation = 0;
				}
				
				if ((saturation < 130) && (lightness > 100)) {
		//			saturation = 0;
				}
			}
			
			
			cvtImg.at<cv::Vec3b>(indx,indy)[2] = saturation;
		}
	}
}

cv::Mat ColorDetect::detect(const cv::Mat &img)
{	
	cv::Mat in, cvtImg, thrImg, eImg, dImg, bettoImg;
	cv::Mat element1(4, 4, CV_8U, cv::Scalar(1));
	cv::Mat element2(6, 6, CV_8U, cv::Scalar(1));
	std::vector<std::vector<cv::Point> > contours;
	in = img;
	
	// transform image from BGR to HLS
	cv::cvtColor(in, cvtImg, CV_BGR2HLS, 0);
	
	// apply color filter
	colorFilter_Red (cvtImg);
	//colorFilter_8Bit (cvtImg);
	//colorFilter_Saturate (cvtImg);
	
	// transform image back from HLS to BGR
	cv::cvtColor(cvtImg, bettoImg, CV_HLS2BGR, 0);
	
	// transform image to binary
	thrImg = getThresh(cvtImg);

	// simplify the image
	//dImg = thrImg;
		
	cv::dilate(thrImg, dImg, element1);
	cv::dilate(dImg, dImg, element1);
	for (int h = 0; h>2; h++)
	{
		cv::erode(dImg, dImg, element2);
	}

	// find blobs
	cv::findContours(dImg, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
	std::vector<std::vector<cv::Point> > contours_poly(contours.size());
	std::vector<cv::Rect> boundRect(contours.size());
	cv::Rect superRect;
	int superArea = 0;

	for (unsigned int i = 0; i < contours.size(); i++)
	{
		if (contourArea(contours[i]) > 500) {
			cv::approxPolyDP(cv::Mat(contours[i]), contours_poly[i], 25, true);
			boundRect[i] = cv::boundingRect(cv::Mat(contours_poly[i]));
			
			if (contourArea(contours[i]) > superArea) {
				superArea = contourArea(contours[i]);
				superRect = boundRect[i];
			}
		}
	}

	/*
	for (unsigned int j = 0; j < contours.size(); j++)
	{
		cv::rectangle(bettoImg, boundRect[j], cv::Scalar(0, 255, 0), 2);
	}
	*/
	
	if (superArea > 0) {
		cv::rectangle(bettoImg, superRect, cv::Scalar(0, 255, 0), 2);
	}

	return bettoImg;
}

void ColorDetect::update()
{	
	cv::Mat src;
	cv::namedWindow("Color Detect");

	for (;;)
	{
		vcap >> src;
		cv::imshow("Color Detect", detect(src));
		if (cv::waitKey(45) >= 0) break;
	}
}
