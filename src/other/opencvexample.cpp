/*----------------------------------------------------------------------------
  
    CS223B Project: Find Mii

    This is the example program for using C++ and OpenCV in this project
    
-----------------------------------------------------------------------------*/
#include <opencv2/opencv.hpp>

int main(int argc, char *argv[])
{
    std::cout << "Hello Mii" << std::endl;
    
    // You may write as many C++ programs as needed (change the Makefile to make 
    // ALL of them by running 'make' in your submission directory)
    
    // You may return your result to the Matlab function in any way you want
    // (For example, output ASCII files here, and read it there, or use MEX file
    //  if you know how-to)
    
    // We should be able to re-generate ALL your C++ progrom by running 'make'
    // in your submission directory, and they should be invoked correctly by the
    // Matlab infrastructure code.
    
    // If you work on the 'corn' clusters, use:
    // setenv LD_LIBRARY_PATH /afs/ir/class/cs231a/opencv/lib   
    // (Make sure your program works properly this way, because this is how we
    //  will run your program for final scoring.) 
    
    
    
    /* -------- Guidelines for processing avi files in OpenCV -------------- */
    
    
    // OpenCV supports capturing images from a video file (AVI).

    // Initializing capture from a file:
	// Open the video file
	cv::VideoCapture capture("filename.avi");
	// check if video successfully opened
	if (!capture.isOpened())
		return 1;
	cv::Mat frame; // current video frame
	// for all frames in video
	while (true) {
		capture >> frame;
		if(!frame.data) break;
		// process the frame here.
	}
	// Close the video file.
	// Not required since called by destructor
	capture.release();
    return 0;
}
