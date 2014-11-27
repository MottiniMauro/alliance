#include "ColorDetect.h"

#define VIDEO_WINDOW_WIDTH 160
#define VIDEO_WINDOW_HEIGHT 120

ColorDetect::ColorDetect()
{
	getVideo();
}

ColorDetect::~ColorDetect() { }

void ColorDetect::getVideo()
{
	vcap.open(0); //0 = connected webcam

    // set video image size
    //vcap.set(CV_CAP_PROP_FRAME_WIDTH, VIDEO_WINDOW_WIDTH);
    //vcap.set(CV_CAP_PROP_FRAME_HEIGHT, VIDEO_WINDOW_HEIGHT);
	
	if (!vcap.isOpened())
		std::cout << "Could not open video input stream" << std::endl;
	
}

// convert image pixels to white if they are red, and black if they are out of range.

cv::Mat getThresh_Red (const cv::Mat &inImg)
{
	cv::Mat imgThresh(inImg.size(), inImg.type());
	
	cv::inRange(inImg, cv::Scalar(0, 50, 50), cv::Scalar(20, 200, 255), imgThresh);
	
	return imgThresh;
}

// convert image pixels to white if they are turquoise, and black if they are out of range.

cv::Mat getThresh_Turquoise (const cv::Mat &inImg)
{
	cv::Mat imgThresh(inImg.size(), inImg.type());
	
	cv::inRange(inImg, cv::Scalar(30, 30, 50), cv::Scalar(170, 200, 255), imgThresh);
	
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

// grey and turquoise

void colorFilter_Turquoise (cv::Mat &cvtImg) {
	
	int width = cvtImg.cols;
	int height = cvtImg.rows;
	
	for( int indx = 0; indx < height; indx++ ) {
		for( int indy = 0; indy < width; indy++ ) {
		
			int lightness = cvtImg.at<cv::Vec3b>(indx,indy)[1];
			int saturation = cvtImg.at<cv::Vec3b>(indx,indy)[2];
			
			// remove green-blue
			if (cvtImg.at<cv::Vec3b>(indx,indy)[0] < 50) {
				saturation = 0;
			}
			
			if (cvtImg.at<cv::Vec3b>(indx,indy)[0] > 170) {
				saturation = 0;
			}
			
				
			// remove black
			if (lightness < 60) {
				saturation = 0;
			}

            if (saturation < 110 && lightness < 80) {
				//saturation = 0;
			}
		
			// remove grey
			if (saturation < 60) {
				saturation = 0;
			}
		
			// remove white
			if (lightness > 140) {
				saturation = 0;
			}
			
			cvtImg.at<cv::Vec3b>(indx,indy)[2] = saturation;
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
			
			// tweak red
			cvtImg.at<cv::Vec3b>(indx,indy)[0] = (cvtImg.at<cv::Vec3b>(indx,indy)[0] + 10) % 180;
			
			// remove non-red
			if (cvtImg.at<cv::Vec3b>(indx,indy)[0] > 14) {
				saturation = 0;
			}
			
			// aplly other filters
			else {
				cvtImg.at<cv::Vec3b>(indx,indy)[0] = cvtImg.at<cv::Vec3b>(indx,indy)[0] / 2;
				
				// remove black
				if (lightness < 50) {
					saturation = 0;
				}
			
				// remove grey
				if (saturation < 60) {
				//	saturation = 0;
				}
			
				// remove white
				if (lightness > 130) {
					saturation = 0;
				}

                if (saturation < 120 && lightness < 110) {
				   // saturation = 0;
			    }
			
				// remove skin
				if ((saturation < 80) && (lightness > 130)) {
		//			saturation = 0;
				}
				
				if ((saturation < 100) && (lightness > 100)) {
		//			saturation = 0;
				}
			}
			
			cvtImg.at<cv::Vec3b>(indx,indy)[2] = saturation;
		}
	}
}

// returns the blob center.
// range is normalized to -100 to +100 (negative is left, positive is right, 0 is center).
// color 1 is red, else is alternate color.

cv::Point2i ColorDetect::detect (int color)
{	
    cv::Mat img;

    vcap >> img;

	cv::Mat in, cvtImg, thrImg, eImg, dImg, bettoImg;
	cv::Mat element1(4, 4, CV_8U, cv::Scalar(1));
	cv::Mat element2(6, 6, CV_8U, cv::Scalar(1));
	std::vector<std::vector<cv::Point> > contours;
	
	// transform image from BGR to HLS
	cv::cvtColor(img, img, CV_BGR2HLS, 0);
	
	// apply color filter
	
	if (color == 1) {
		colorFilter_Red (img);
	}
	else {
		colorFilter_Turquoise (img);
	}
	
	//colorFilter_8Bit (cvtImg);
	//colorFilter_Saturate (cvtImg);
	
	// transform image back from HLS to BGR
	cv::cvtColor(img, bettoImg, CV_HLS2BGR, 0);
	
	// transform image to binary
	if (color == 1) {
		thrImg = getThresh_Red (img);
	}
	else {
		thrImg = getThresh_Turquoise (img);
	}

	// simplify the image
	//dImg = thrImg;
	for (int h = 0; h>2; h++)
	{
		cv::erode(dImg, dImg, element2);
	}
	cv::dilate(thrImg, dImg, element1);
	//cv::dilate(dImg, dImg, element1);

	cv::blur (dImg, dImg, cv::Size(4,4));

	// find blobs
	cv::findContours(dImg, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
	std::vector<std::vector<cv::Point> > contours_poly(contours.size());
	std::vector<cv::Rect> boundRect(contours.size());
	cv::Rect superRect;
	int superArea = 0;

    cv::Point2f center;

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

    // if the blob was detected, ...
    if (superArea > 0) {

        // get blob center
        center = cv::Point2f(superRect.tl().x + superRect.size().width / 2, superRect.tl().y + superRect.size().height / 2);

        // draw center in video window
        cv::line( bettoImg, center, center + cv::Point2f( 2, 0), cv::Scalar( 0, color?0:255, color?255:0), 7 );

	    /*
	    for (unsigned int j = 0; j < contours.size(); j++)
	    {
		    cv::rectangle(bettoImg, boundRect[j], cv::Scalar(0, 255, 0), 2);
	    }
	    */

        // draw blob in video window
	
	    if (superArea > 0) {
		    cv::rectangle(bettoImg, superRect, cv::Scalar(0, color?0:255, color?255:0), 1);
	    }
    }
	
    cv::imshow("Color Detect", bettoImg);

    // normalize blob center to -100 to +100.
    
    if (superArea > 0) {

        cv::Point2i center_n = cv::Point2i ((center.x * 200 / VIDEO_WINDOW_WIDTH) - 100, (center.y * 200 / VIDEO_WINDOW_HEIGHT) - 100);

	    return center_n;
    }
    else {
        return cv::Point2i (-999, -999);
    }

}
