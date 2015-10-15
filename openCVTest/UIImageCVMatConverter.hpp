//
//  UIImageCVMatConverter.h
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface UIImageCVMatConverter : NSObject {
    
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat withUIImage:(UIImage*)image;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)scaleAndRotateImageFrontCamera:(UIImage *)image;
+ (UIImage *)scaleAndRotateImageBackCamera:(UIImage *)image;

@end