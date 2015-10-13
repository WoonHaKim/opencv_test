//
//  ViewController.h
//  openCVTest
//
//  Created by 김운하 on 2015. 10. 12..
//  Copyright © 2015년 bnsworks. All rights reserved.
//


//  ViewController.h

#import <iostream>
#import <UIKit/UIKit.h>
#import <opencv2/highgui/highgui.hpp>

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/core/core_c.h>

using namespace cv;
using namespace std;

double min_face_size=30;
double max_face_size=480;

double min_eye_size=10;
double max_eye_size=20;

CascadeClassifier face;

String faceCascade="haarcascade_frontalface_alt2.xml";

@interface ViewController : UIViewController<CvVideoCameraDelegate>{
    IBOutlet UIImageView *sampleView;
    CvVideoCamera* videoCamera;

    Mat temp;
}

@property (nonatomic, retain) CvVideoCamera* camera;


@end
