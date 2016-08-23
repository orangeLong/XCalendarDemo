//
//  XCalenderCommon.h
//  MobileCashier
//
//  Created by LiX i n long on 16/7/26.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XTallyDate) {
    XTallyDateLastDay,
    XTallyDateLastWeek,
    XTallyDateLastMonth,
    XTallyDateCustom,
};

@interface XCalenderCommon : NSObject

+ (NSArray *)dateSignWith:(XTallyDate)dateSign;

+ (void)dateSignWith:(XTallyDate)dateType presentVC:(UIViewController *)presentVC completeBlock:(void(^)(NSString *first, NSString *last))completeBlock;
/**
 *  判断两个时间是否是同一天
 *
 *  @param first 第一天
 *  @param last  第二天
 *
 *  @return 
 */
+ (BOOL)compareDateStrWithFirst:(NSString *)first last:(NSString *)last;

@end
