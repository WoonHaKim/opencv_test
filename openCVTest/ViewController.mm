//
//  ViewController.m
//  openCVTest
//
//  Created by 김운하 on 2015. 10. 12..
//  Copyright © 2015년 bnsworks. All rights reserved.
//


#import "ViewController.hpp"
#import "UIImageCVMatConverter.hpp"
#import "subMiniViewController.hpp"

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/video/video.hpp"
#include "opencv2/calib3d/calib3d.hpp"

#include "opencv2/features2d/features2d.hpp"

#include <algorithm>

@interface ViewController ()

@end

@implementation ViewController


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}
- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    [_camera adjustLayoutToInterfaceOrientation:orientation];
/*
    [_camera stop];
    switch (orientation)
    {
 
        case UIInterfaceOrientationPortrait:
            _camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            _camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            _camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
        {
            _camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
    [_camera start];
             */
}
-(void)viewDidDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadHaarFiles];
    // Do any additional setup after loading the view, typically from a nib.

    _detLabel.text=@"";
    _camera = [[CvVideoCamera alloc]initWithParentView:sampleView];
    _camera.delegate = self;
    _camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _camera.defaultAVCaptureVideoOrientation =AVCaptureVideoOrientationPortrait;
    _camera.rotateVideo = YES;

    if(IS_IPHONE){
        _camera.defaultFPS = DEFAULT_FPS*3;
        min_face_size=250;
        _camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    }
    else{
        _camera.defaultFPS = DEFAULT_FPS;
        min_face_size=100;
        _camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    }
    
    [_camera start];
    
    isTracking=false;
    isDetecting=false;
    no_detect=0;
    
    //timer=[NSTimer scheduledTimerWithTimeInterval:TIMER_FACE_REPEAT target:self selector:@selector(showPersonInfo) userInfo:nil repeats:YES];
    //timer=[NSTimer scheduledTimerWithTimeInterval:TIMER_FACE_REPEAT target:self selector:@selector(updateQueue) userInfo:nil repeats:YES];

    //Feature
    
    ptrDetector= cv::ORB::create();
    ptrExtractor= cv::ORB::create();
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pen" ofType:@"bmp"];
    const char * cpath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    sample = imread( cpath, CV_LOAD_IMAGE_UNCHANGED );
    cvtColor(sample, sample_copy, CV_BGR2GRAY);

    ptrDetector->detect(sample,sampleKeypoints);

    ptrExtractor->compute(sample, sampleKeypoints, sampleDesctiptor);
    sampleDesctiptor.convertTo(sampleDesctiptor, CV_32F);

    
    //[self startTrack:temp];
}

-(void)loadHaarFiles{
    // harrcascade 파일 로드
    NSString * const TFCascadeFilename = @"haarcascade_frontalface_alt2";//Strings of haar file names
    NSString *TF_cascade_name = [[NSBundle mainBundle] pathForResource:TFCascadeFilename ofType:@"xml"];
    //Load haar file, return error message if fail
    if (!face.load( [TF_cascade_name UTF8String] )) {
        NSLog(@"Could not load TF cascade!");
    }
    NSString * const TFCascadeEyeFilename = @"haarcascade_eye";//Strings of haar file names
    NSString *TF_cascade_eye_name = [[NSBundle mainBundle] pathForResource:TFCascadeEyeFilename ofType:@"xml"];
    //Load haar file, return error message if fail
    if (!eye.load( [TF_cascade_eye_name UTF8String] )) {
        NSLog(@"Could not load TF cascade!");
    }
    
    NSString * const keyFilename = @"key";//Strings of haar file names
    NSString *keyName = [[NSBundle mainBundle] pathForResource:keyFilename ofType:@"png"];
    //Load haar file, return error message if fail
    if (!cvLoadImage([keyName UTF8String], -1)) {
        NSLog(@"Could not load Picture key!");
    }
    
}


- (IBAction)btnFlip:(id)sender {
    [_camera stop];
    if (_camera.defaultAVCaptureDevicePosition==AVCaptureDevicePositionBack){
        _camera.defaultAVCaptureDevicePosition=AVCaptureDevicePositionFront;
    }else{
        _camera.defaultAVCaptureDevicePosition=AVCaptureDevicePositionBack;
    }
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
    
    Mat descriptor_1;
    
    cvtColor(image, image_copy, CV_BGR2GRAY);
    
    //Feture Detection
    

    std::vector<KeyPoint> keypoints;
    
    ptrDetector= cv::ORB::create();
    ptrExtractor= cv::ORB::create();
    
    ptrDetector->detect(image_copy,keypoints);
    ptrExtractor->compute(image_copy, keypoints, descriptor_1);
    
    
    //drawKeypoints(image_copy, keypoints, image_copy2,cv::Scalar::all(-1),DrawMatchesFlags::DEFAULT);
    //drawKeypoints(sample_copy , sampleKeypoints, image_copy2,cv::Scalar::all(-1),DrawMatchesFlags::DEFAULT);
    
    if(descriptor_1.type()!=CV_32F) {
    descriptor_1.convertTo(descriptor_1, CV_32F);
    }
    if(sampleDesctiptor.type()!=CV_32F) {
        sampleDesctiptor.convertTo(sampleDesctiptor, CV_32F);
    }
    //sampleDesctiptor.convertTo(sampleDesctiptor, CV_32F);

    if (sampleDesctiptor.empty() ){
        NSLog(@"sample_descriptor empty!!");
    }else if (descriptor_1.empty()){
        NSLog(@"descriptor_camera empty!!");
    }
    
    FlannBasedMatcher matcher;
    std::vector< DMatch > matches;
    matcher.match(descriptor_1, sampleDesctiptor, matches);
    
    double max_dist = 0; double min_dist = 120;
    //-- Quick calculation of max and min distances between keypoints
    for( int i = 0; i < descriptor_1.rows; i++ )
    { double dist = matches[i].distance;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
    }
    std::vector< DMatch > good_matches;
    
    for( int i = 0; i < descriptor_1.rows; i++ )
    { if( matches[i].distance <= max(2*min_dist, 0.02) )
    { good_matches.push_back( matches[i]); }
    }
    
    Mat img_matches;
    
    drawMatches( image_copy, keypoints, sample_copy ,sampleKeypoints,
                good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
                vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
    
    
    image=img_matches;

    
    
    temp=image;
    //image=[self detectFace:image copy:image_copy];
    
}

-(std::vector<KeyPoint>)getKeyPoints:(cv::Mat)refImg{
    Mat refImg_copy;
    cvtColor(refImg, refImg_copy, CV_BGR2GRAY);

    cv::FeatureDetector detector;
    cv::DescriptorExtractor extractor;
    std::vector<KeyPoint> keypoints;

    cv::Ptr<cv::FastFeatureDetector> ptrBrisk = cv::FastFeatureDetector::create();
    cv::Ptr<cv::DescriptorExtractor> ptrExtractor;
    
    cv::Ptr<cv::FeatureDetector> detector_ptr;
    ptrBrisk->detect(refImg_copy,keypoints);
    
    return keypoints;
}

-(Mat)detectFace:(Mat)image copy:(Mat)copy_image{
    //Haar cascading을 통하여 얼굴을 잡아낸다.
    //잡아낸 얼굴은 트래커에 전달한다.
    
    dispatch_sync(dispatch_get_main_queue(), ^{
    face_detect=[self detectFaces:image];
    std::vector<cv::Mat>roi=[self detectFacesImg:image cood:face_detect];
    });
        
    for(int i=0; i<(int)face_detect.size() ;i++){
       rectangle(image, face_detect[i],cv::Scalar(0,255,0),2);//Detection Rectengle
    }
    return image;
 
}

-(std::vector<cv::Rect>)detectFaces:(cv::Mat)refImg{
    Mat copyRefImg;
    std::vector<cv::Rect>detectFaces_v;
    
    cvtColor(refImg, copyRefImg, CV_BGR2GRAY);
    face.detectMultiScale(copyRefImg, detectFaces_v, 1.2,3,0|CV_HAAR_SCALE_IMAGE,cv::Size(min_face_size,min_face_size));

    return detectFaces_v;
    
}

-(std::vector<cv::Mat>)detectFacesImg:(cv::Mat)refImg cood:(std::vector<cv::Rect>)coordinates{
    Mat copyRefImg;
    std::vector<cv::Mat>filteredDetectFaces;
    filteredDetectFaces.clear();
    for(int i=0; i<(int)coordinates.size() ;i++){
        Mat roi=refImg(coordinates[i]);
        filteredDetectFaces.push_back(roi);
    }
    
    return filteredDetectFaces;
}













































-(void)featureDetection:(cv::Mat &)image{
    
    Mat image_copy;
    Mat image_copy2;
    
    Mat descriptor_1;
    
    cvtColor(image, image_copy, CV_BGR2GRAY);
    
    //Feture Detection
    
    
    cv::FeatureDetector detector;
    cv::DescriptorExtractor extractor;
    
    std::vector<KeyPoint> keypoints;
    
    cv::Ptr<cv::FastFeatureDetector> ptrFeature = cv::FastFeatureDetector::create();
    
    ptrFeature->detect(image_copy,keypoints);
    
    ptrExtractor->compute(image_copy, keypoints, descriptor_1);
    
    
    // drawKeypoints(image_copy, keypoints, image_copy2,cv::Scalar::all(-1),DrawMatchesFlags::DEFAULT);
   // drawKeypoints(sample_copy, sampleKeypoints, image_copy2,cv::Scalar::all(-1),DrawMatchesFlags::DEFAULT);
    
    descriptor_1.convertTo(descriptor_1, CV_32F);
    
    if (sampleDesctiptor.empty() ){
        NSLog(@"sample_descriptor empty!!");
    }else if (descriptor_1.empty()){
        NSLog(@"descriptor_camera empty!!");
    }

    FlannBasedMatcher matcher;
    std::vector< DMatch > matches;
    matcher.match(descriptor_1, sampleDesctiptor, matches);
    
    double max_dist = 0; double min_dist = 180;
    //-- Quick calculation of max and min distances between keypoints
    for( int i = 0; i < descriptor_1.rows; i++ )
    { double dist = matches[i].distance;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
    }
        
    std::vector< DMatch > good_matches;
    
    for( int i = 0; i < descriptor_1.rows; i++ )
    { if( matches[i].distance <= max(2*min_dist, 0.02) )
    { good_matches.push_back( matches[i]); }
    }
    
    Mat img_matches;
    
    drawMatches( image_copy, keypoints, sample_copy ,sampleKeypoints,
                good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
                vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
    
    
    image=image_copy2;
    
}



-(Mat)trackFace:(Mat)image copy:(Mat)copy_image{
    //인자를 받는다
    //얼굴을 추적한다
    //추적에 실패하면 예전 상태로 돌아간다
    return image;
}
- (void)showPersonInfo{
    float viewPropX=sampleView.frame.size.width/(temp.size().width);
    float viewPropY=sampleView.frame.size.height/(temp.size().height);
    
    for (UIView *subView in sampleView.subviews){
        [subView removeFromSuperview];
    }
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    subMiniViewController *personViewController= [storyboard instantiateViewControllerWithIdentifier:@"infoView"];

    for (int i=0;i<face_prev.size();i++){
        CGRect contentFrame=CGRectMake((int)(viewPropX*face_prev[i].x),(int)(viewPropY*face_prev[i].y), 200, 60);
        personViewController.view.frame=contentFrame;
        if (face_prev.size()!=0 || face_detect.size()!=0) {
            [sampleView addSubview:personViewController.view];
        }    
    }
}
- (void)updateCount{
    self.detLabel.text=[NSString stringWithFormat:@"Tracking: %lu",face_prev.size()];
}


- (void)updateQueue{
    //이동 거리 기반 큐를 업데이트 한다.
    //사람이 없으면?->추가, 원본을 버림
    //사람이 있으면?->원본 대체
    //
    
    
    int j=0, i=0;
    std::vector<cv::Rect>face_detect_v=face_detect;
    if (face_prev.size()!=0){
        for (j=0;j<(int)face_detect_v.size();j++){
            for (i=0;i<(int)face_prev.size() ;i++){
                if (nearPoint(face_prev[i].x, face_prev[i].y, face_detect_v[j].x, face_detect_v[j].y, 600, 800)){
                    NSLog(@"Track catch!, %d,%d -> %d,%d",face_prev[i].x, face_prev[i].y, face_detect_v[j].x, face_detect_v[j].y);
                    face_prev[i].x=face_detect_v[j].x;
                    face_prev[i].y=face_detect_v[j].y;
                    face_prev[i].width=face_detect_v[j].width;
                    face_prev[i].height=face_detect_v[j].height;
                    
                }
            }
                NSLog(@"No Match");
                if (face_prev.size()>=face_detect.size()){
                    face_prev.erase(face_prev.begin()+i);
                }else{
                    face_prev.insert(face_prev.begin(),face_detect_v[j]);
                    
                
           }
        }
    }
    else{
        for (int j=0;j<(int)face_detect_v.size();j++){
            face_prev.insert(face_prev.begin(),face_detect_v[j]);
        }
    }
    [self updateCount];

}

-(void)detectPerson:(Mat)roi_image{
    double min, max;
    CvPoint left_top;
    
    IplImage *trans = new IplImage(roi_image);

 //   NSString * const keyFilename = @"key";//Strings of haar file names
//    NSString *keyName = [[NSBundle mainBundle] pathForResource:keyFilename ofType:@"jpg"];

    IplImage *B = new IplImage([UIImageCVMatConverter cvMatFromUIImage:[UIImage imageNamed:@"key.jpg"]]); // templete를 읽는다.
    IplImage* C = cvCreateImage(cvSize( B->width - trans->width+1, B->height - trans->height+1 ), IPL_DEPTH_32F, 1 ); // 상관계수를 구할 이미지(C)
    
    cvMatchTemplate(trans, B, C, CV_TM_CCOEFF_NORMED); // 상관계수를 구하여 C 에 그린다.
    cvMinMaxLoc(C, &min, &max, NULL, &left_top);
    
    
    
    
}


- (void)startTrack:(Mat)roi_image{
    Mat copy_temp;
    tracker_opencv tracker;
    cvtColor(temp, roi_image, CV_BGR2GRAY);
    for (int i=0; i<face_detect.size()  && isTracking==false ; i++) {
        face_tracker[i].init(roi_image, face_detect[i]);
        face_tracker[i].run(roi_image, face_detect[i]);
        isTracking=true;
    }
}
-(void) detatchFace:(Mat)image{
    for(int i=0; i<(int)face_detect.size() ;i++){
        Mat roi=image(face_detect[i]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *roi_img=[UIImageCVMatConverter UIImageFromCVMat:roi];
            detailView.image=roi_img;
        });
    }
}


- (IBAction)stop:(id)sender {
    [_camera stop];
}

- (IBAction)start:(id)sender {
    [_camera start];
}

@end
