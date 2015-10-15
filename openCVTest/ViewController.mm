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

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
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
    
    _detLabel.text=@"";
    _camera = [[CvVideoCamera alloc]initWithParentView:sampleView];
    _camera.delegate = self;
    _camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _camera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _camera.rotateVideo = YES;
    _camera.defaultFPS = DEFAULT_FPS;
    
    [_camera start];
}
- (IBAction)btnAddSubView:(id)sender {
    subMiniViewController *personViewController;
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
    
    image=[self detectFace:image copy:image_copy];
    
}
-(Mat)detectFace:(Mat)image copy:(Mat)copy_image{
    //Haar cascading을 통하여 얼굴을 잡아낸다.
    cvtColor(image, copy_image, CV_BGR2GRAY);
    Mat roi;
    std::vector<cv::Rect>eye_pos;

    face.detectMultiScale(copy_image, face_pos, 1.2,3,0|CV_HAAR_SCALE_IMAGE,cv::Size(min_face_size,min_face_size));
    

    for(int i=0; i<(int)face_pos.size() ;i++){
        roi=copy_image(face_pos[i]);
       // [self detectPerson:image];
        
        
        rectangle(image, face_pos[i],cv::Scalar(0,255,0),2);
        String face_text=[[NSString stringWithFormat:@"Face %d",i]UTF8String];
        putText( image , face_text ,cvPoint(face_pos[i].x-5,face_pos[i].y-10), FONT_HERSHEY_PLAIN, 0.7f, Scalar(50,50,50) );
        
        
        
        eye.detectMultiScale(roi, eye_pos, 1.1,2,0|CV_HAAR_SCALE_IMAGE,cv::Size(min_eye_size,min_eye_size));

        for(int j=0; j<(int)eye_pos.size() ;j++){
            cv::Point center(face_pos[i].x+eye_pos[j].x+(eye_pos[j].width/2),face_pos[i].y+eye_pos[j].y+(eye_pos[j].height/2));
            int radius=cvRound((eye_pos[j].width+eye_pos[j].height)*0.2);
            circle(image, center, radius, cv::Scalar(0,0,255),2);
        }
        
    }
    
    if (face_pos.size()>0){
    [self updateQueue:face_pos];
    }
    return image;
}

- (void)updateCount{
    NSLog(@"Faces?: %lu",face_prev.size());
    self.detLabel.text=[NSString stringWithFormat:@"Faces?: %lu",face_prev.size()];
    
}

- (void)updateQueue:(std::vector<cv::Rect>)face_pos_v{
    //이동 거리 기반 큐를 업데이트 한다.
    //사람이 없으면?->추가, 원본을 버림
    //사람이 있으면?->원본 대체
    //
    
    double propotionX,propotionY;
    if (face_prev.size()!=0){
        for (int i=0;i<(int)face_prev.size();i++){
            for (int j=0;j<(int)face_pos_v.size();j++){
                propotionX=(face_prev[i].x-face_pos_v[j].x)/face_prev[i].x;
                propotionY=(face_prev[i].y-face_pos_v[j].y)/face_prev[i].y;
                NSLog(@"%d,%d, match:%1.8f",i,j,(propotionX+propotionY)/2);
                if ((propotionX<PROP_MAX && propotionX>-PROP_MAX)&&(propotionY<PROP_MAX && propotionY>-PROP_MAX)){
                    self.levelLabel.text=@"Track catch";
                    NSLog(@"Track catch!");
                    face_prev[i].x=face_pos_v[i].x;
                    face_prev[i].y=face_pos_v[i].y;
                    break;
                }

                NSLog(@"No Match");
           
                face_prev.erase(face_prev.begin()+i);
                face_prev.insert(face_prev.begin(),face_pos_v[j]);
                
            }
        }
    }
    else{
        for (int j=0;j<(int)face_pos_v.size();j++){
            face_prev.insert(face_prev.begin(),face_pos_v[j]);
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
    IplImage* C = cvCreateImage( cvSize( B->width - trans->width+1, B->height - trans->height+1 ), IPL_DEPTH_32F, 1 ); // 상관계수를 구할 이미지(C)
    
    cvMatchTemplate(trans, B, C, CV_TM_CCOEFF_NORMED); // 상관계수를 구하여 C 에 그린다.
    cvMinMaxLoc(C, &min, &max, NULL, &left_top);
    
    
}

- (IBAction)stop:(id)sender {
    [_camera stop];
}

- (IBAction)start:(id)sender {
    [_camera start];
}

@end
