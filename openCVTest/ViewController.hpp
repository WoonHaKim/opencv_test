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

#import "tracker_opencv.h"

#import "constants.h"

using namespace cv;
using namespace std;

double min_face_size=40;
double max_face_size=480;

double min_eye_size=10;
double max_eye_size=20;

std::vector<cv::Rect>face_pos;
std::vector<cv::Rect>face_prev;

CascadeClassifier face;
CascadeClassifier eye;

@interface ViewController : UIViewController<CvVideoCameraDelegate>{
    IBOutlet UIImageView *sampleView;
    CvVideoCamera* videoCamera;

    Mat temp;
    Mat prev;
}

@property (nonatomic, retain) CvVideoCamera* camera;

@property (weak, nonatomic) IBOutlet UILabel *detLabel;
@property (nonatomic) NSInteger detectedFaces;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end
