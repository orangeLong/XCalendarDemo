//
//  XCalenderViewController.h
//  MobileCashier
//
//  Created by LiX i n long on 16/7/26.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "BaseViewController.h"

@interface XCalenderViewController : BaseViewController

@property (nonatomic, copy) void(^completeBlock)(NSString *first, NSString *last);

@end
