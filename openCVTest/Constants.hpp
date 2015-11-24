//
//  Constants.h
//  openCVDetector
//
//  Created by 김운하 on 2015. 10. 26..
//  Copyright © 2015년 bnsworks. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import <opencv2/opencv.hpp>

#import <opencv2/highgui/highgui.hpp>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/core/core_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/stitching/detail/util.hpp>

#import <Album.h>
#import <MediaPlayerViewController.h>

typedef struct screenObject{
    int objID;
    int objTrackFail;

    int objPlay;

    Album* objAlbum;
    MediaPlayerViewController *objVC;


    cv::Rect objFollowRect;
    cv::Point2f objLocation;

    cv::Mat objInitMat;
}object;

typedef struct rectComp{
    std::vector<cv::Rect>rect;
    std::vector<cv::RotatedRect>rotRect;
}combinedRect;

typedef struct albumSearchResult{
    std::vector<cv::KeyPoint> KeyPoints;
    cv::Mat descriptor;
    cv::Mat refAlbumCover;
}albumSearchResult;

#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define COVER_MAX 4

//전체 Flow Signal State

#define STATE_ROI_MATCH 0
#define STATE_ROI_TRACK 1

#define STATE_MATCH_ON 2
#define STATE_MATCH_OFF 3

#define STATE_TRACK_ON 4
#define STATE_TRACK_LOST 5
#define STATE_TRACK_OFF 6

#define STATE_OVERLAY_ON 7
#define STATE_OVERLAY_OFF 8

//카메라 작동 FPS
#define DEFAULT_FPS 15


//영상 처리 알고리즘 설정
#define DETECT_LINE_METHOD_CANNY 0
#define DETECT_LINE_METHOD_GAUSSIAN 1
#define DETECT_LINE_METHOD_HYBRID 2
#define DETECT_LINE_METHOD_CONTOUR 3

//Coutour 설정
#define CONTOUR_RECT_RATIO_LIMIT 1.61803
#define CONTOUR_RECT_AREA_LIMIT 12000

//코너를 몇 픽셀 이내의 선들로 결정할지 지정
#define CORNER_PIXEL_THRESHOLD 20


#define DETECT_AREA_MIN 2000
#define CONTOUR_RECT_WIDTH_MIN 200
#define CONTOUR_RECT_HEIGHT_MIN 200

//특징점 매칭 알고리즘 설정

#define DETECT_FEATURE_FAST 0
#define DETECT_FEATURE_BRISK 1
#define DETECT_FEATURE_ORB 2
#define DETECT_FEATURE_ORB_REF 21
#define DETECT_FEATURE_KAZE 3
#define DETECT_FEATURE_AKAZE 4


#define DETECT_VEC_THRESHOLD 7

//Optical Flow 검출

#define OPTICAL_MAX_CORNERS 70

//오버레이 정보창 가로 세로

#define OVERLAY_WIDTH 200
#define OVERLAY_HEIGHT 200

#endif /* Constants_h */
