//
//  Constants.h
//  openCVDetector
//
//  Created by 김운하 on 2015. 10. 26..
//  Copyright © 2015년 bnsworks. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad



//카메라 작동 FPS
#define DEFAULT_FPS 15


//영상 처리 알고리즘 설정
#define DETECT_LINE_METHOD_CANNY 0
#define DETECT_LINE_METHOD_GAUSSIAN 1
#define DETECT_LINE_METHOD_HYBRID 2
#define DETECT_LINE_METHOD_CONTOUR 3

//Coutour 설정
#define CONTOUR_RECT_RATIO_LIMIT 2.5
#define CONTOUR_RECT_AREA_LIMIT 120000

//코너를 몇 픽셀 이내의 선들로 결정할지 지정
#define CORNER_PIXEL_THRESHOLD 20


#define DETECT_AREA_MIN 3000
#define CONTOUR_RECT_WIDTH_MIN 200
#define CONTOUR_RECT_HEIGHT_MIN 200

//특징점 매칭 알고리즘 설정

#define DETECT_FEATURE_FAST 0
#define DETECT_FEATURE_BRISK 1
#define DETECT_FEATURE_ORB 2

#endif /* Constants_h */
