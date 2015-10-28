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

#define CORNER_PIXEL_THRESHOLD 10

#define DEFAULT_FPS 15

#define DETECT_LINE_METHOD_CANNY 0
#define DETECT_LINE_METHOD_GAUSSIAN 1
#define DETECT_LINE_METHOD_HYBRID 2

#endif /* Constants_h */
