//
//  subMiniViewController.h
//  openCVTest
//
//  Created by 김운하 on 2015. 10. 15..
//  Copyright © 2015년 bnsworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface subMiniViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *PersonName;
@property (weak, nonatomic) IBOutlet UILabel *Location;
@property (strong, nonatomic) IBOutlet UIImageView *personImage;

@end
