//
//  XCalenderView.h
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/12.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XCalenderType) {
    XCalenderTypeDay,
    XCalenderTypeWeek,
    XCalenderTypeMonth,
    XCalenderTypeCustom
};

@interface XCalenderView : UIView
/**
 *  单个日期高度，默认为viewWidth / 7
 */
@property (nonatomic, assign) CGFloat dateHeight;
/**
 *  日历起始时间 默认为2010年1月1日
 */
@property (nonatomic, strong) NSDate *startDate;
/**
 *  点击确认后的回调
 */
@property (nonatomic, copy) void(^confirmBlock)(NSString *startDate, NSString *endDate);
/**
 *  选中日期间隔最大值 day 默认为NSUIntegerMax
 */
@property (nonatomic, assign) NSUInteger dateSpace;

@end
