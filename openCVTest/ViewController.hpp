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
#include <opencv2/imgcodecs/ios.h>



#import "geometry.h"

#import "tracker_opencv.h"
#import "UIImageCVMatConverter.hpp"

#import "constants.h"


using namespace cv;
using namespace std;


double min_face_size=100;
double max_face_size=480;

double min_eye_size=10;
double max_eye_size=20;

std::vector<cv::Rect>face_detect;
std::vector<cv::Rect>face_track;
std::vector<cv::Rect>face_prev;
std::vector<cv::Mat>trackingFace;


std::vector<tracker_opencv>face_tracker;
std::vector<tracker_opencv_obj>tracking_objs;

CascadeClassifier face;
CascadeClassifier eye;

@interface ViewController : UIViewController<CvVideoCameraDelegate>{
    IBOutlet UIImageView *sampleView;
    IBOutlet UIImageView *detailView;
    CvVideoCamera* videoCamera;
    NSTimer *timer;
    Mat temp;
    Mat prev;
    
    int no_detect;
    
    //Tracker
    bool isTracking;
    bool isDetecting;
    
}

@property (nonatomic, retain) CvVideoCamera* camera;

@property (weak, nonatomic) IBOutlet UILabel *detLabel;
@property (nonatomic) NSInteger detectedFaces;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

//ovelaying on images
- (void)showPersonInfo;
- (void)showPersonInfos:(std::vector<tracker_opencv_obj>)detectObjs;
- (void)updateCount;

//tracker
-(std::vector<tracker_opencv>)initTrackers:(cv::Mat)ref_img coodObjs:(cv::Rect)rc;
-(std::vector<tracker_opencv>)startTrackers:(cv::Mat)ref_img coodObjs:(cv::Rect)rc;
-(std::vector<tracker_opencv>)endTrackers;
-(std::vector<tracker_opencv>)updateTrackers:(cv::Mat)ref_img coodObjs:(cv::Rect)rc;

//face detection
-(std::vector<cv::Rect>)detectFaces:(cv::Mat)refImg;
-(std::vector<tracker_opencv_obj>)detectObjs:(cv::Mat)refImg coodObjs:(std::vector<cv::Rect>)coordinates;

//face recognition
-(cv::Mat)recogImgFromCoreData:(cv::Mat)refImg;
-(std::vector<tracker_opencv_obj>)recogObjFromCoreData:(std::vector<cv::Mat>)refImg objID:(int)objID;

@end
