//
//  XCalenderViewController.h
//  MobileCashier
//
//  Created by LiX i n long on 16/7/26.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCalenderViewController : UIViewController

@property (nonatomic, copy) void(^completeBlock)(NSString *first, NSString *last);

@end
