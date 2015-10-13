//
//  ViewController.m
//  openCVTest
//
//  Created by 김운하 on 2015. 10. 12..
//  Copyright © 2015년 bnsworks. All rights reserved.
//


#import "ViewController.hpp"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString * const TFCascadeFilename = @"haarcascade_frontalface_alt2";//Strings of haar file names
    
    NSString *TF_cascade_name = [[NSBundle mainBundle] pathForResource:TFCascadeFilename ofType:@"xml"];
    
    //Load haar file, return error message if fail
    if (!face.load( [TF_cascade_name UTF8String] )) {
        NSLog(@"Could not load TF cascade!");
    }
    _camera = [[CvVideoCamera alloc]initWithParentView:sampleView];
    _camera.delegate = self;
    _camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _camera.rotateVideo = YES;
    _camera.defaultFPS = 60;
    
    [_camera start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) processImage:(cv::Mat &)image
{
    Mat image_copy;
    Mat image_copy2;
    

    
    
    cvtColor(image, image_copy, CV_BGR2GRAY);
    
    image=[self detectFace:image_copy];
//    image_copy=[self findMeterial:image_copy];
    
//    Canny(image_copy, image_copy2, 200,200);
   // cvtColor(image_copy, image, CV_GRAY2BGR);
    
}
-(Mat)detectFace:(Mat)image{
    std::vector<cv::Rect>face_pos;
    face.detectMultiScale(image, face_pos, 1.2,2,0|CV_HAAR_SCALE_IMAGE,cv::Size(min_face_size,min_face_size),cv::Size(max_face_size,max_face_size));
    
    for(int i=0; i<(int)face_pos.size() ;i++){
        //rectangle(image, face_pos[i],cv::Scalar(0,255,255),2);
    }
    return image;
}
-(cv::Mat) findMeterial:(cv::Mat &)src{
    double min, max;
    CvPoint left_top;
    
    IplImage *trans = new IplImage(src);
    IplImage *B = cvLoadImage("key.png", -1); //Key
    IplImage* C = cvCreateImage( cvSize( trans->width - B->width+1, trans->height - B->height+1 ), IPL_DEPTH_32F, 1 ); // 상관계수를 구할 이미지(C)

    
    cvMatchTemplate(trans, B, C, CV_TM_CCOEFF_NORMED); // 상관계수를 구하여 C 에 그린다.
    cvMinMaxLoc(C, &min, &max, NULL, &left_top); // 상관계수가 최대값을 값는 위치 찾기
    cvRectangle(trans, left_top, cvPoint(left_top.x + B->width, left_top.y + B->height), CV_RGB(255,0,0)); // 찾은 물체에 사격형을 그린다.
    
    cv::Mat result=cvarrToMat(trans);

    return result;
}
- (void) findImage:(const char*)imgName1 img2:(const char*)imgName2{
    double min, max;
    CvPoint left_top;
    IplImage *A = cvLoadImage(imgName1, -1); // 책상(A)을 먼저 읽고
    IplImage *B = cvLoadImage(imgName2, -1); // 스테이플러(B)를 읽는다.
    IplImage* C = cvCreateImage( cvSize( A->width - B->width+1, A->height - B->height+1 ), IPL_DEPTH_32F, 1 ); // 상관계수를 구할 이미지(C)
    
    cvMatchTemplate(A, B, C, CV_TM_CCOEFF_NORMED); // 상관계수를 구하여 C 에 그린다.
    cvMinMaxLoc(C, &min, &max, NULL, &left_top); // 상관계수가 최대값을 값는 위치 찾기
    cvRectangle(A, left_top, cvPoint(left_top.x + B->width, left_top.y + B->height), CV_RGB(255,0,0)); // 찾은 물체에 사격형을 그린다.
    

    cvWaitKey(0);
    

}

- (IBAction)stop:(id)sender {
    [_camera stop];
}

- (IBAction)start:(id)sender {
    [_camera start];
}

@end
