//
//  XCalenderCommon.m
//  MobileCashier
//
//  Created by LiX i n long on 16/7/26.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XCalenderCommon.h"

#import "XCalenderDefine.h"
#import "XCalenderViewController.h"

@implementation XCalenderCommon

+ (NSArray *)dateSignWith:(XTallyDate)dateSign
{
    NSInteger day = 0;
    switch (dateSign) {
        case XTallyDateLastDay:
            day = -1;
            break;
        case XTallyDateLastWeek:
            day = -7;
            break;
        case XTallyDateLastMonth:
            day = -30;
            break;
        default:
            day = -1;
            break;
    }
    NSString *beginStr = [self dateStringFromDay:day isBegin:YES];
    NSString *endStr = [self dateStringFromDay:-1 isBegin:NO];
    return @[beginStr, endStr];
}

+ (NSString *)dateStringFromDay:(NSInteger)day isBegin:(BOOL)isBegin
{
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    NSDate *date = [currentCalender dateByAddingUnit:NSCalendarUnitDay value:day toDate:[NSDate date] options:0];
    NSDateComponents *dateComponents = [currentCalender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSString *str = @"00:00:00";
    if (!isBegin) {
        str = @"23:59:59";
    }
    NSString *dateStr = [NSString stringWithFormat:@"%zi-%zi-%zi %@", dateComponents.year, dateComponents.month, dateComponents.day, str];
    return dateStr;
}

+ (void)dateSignWith:(XTallyDate)dateType presentVC:(UIViewController *)presentVC completeBlock:(void(^)(NSString *first, NSString *last))completeBlock
{
    if (dateType != XTallyDateCustom) {
        NSArray *dateArray = [self dateSignWith:dateType];
        if (completeBlock) {
            completeBlock(dateArray.firstObject, dateArray.lastObject);
            XLog_DEBUG(@"选中日期%@", dateArray);
        }
    } else {
        XCalenderViewController *vc = [[XCalenderViewController alloc] init];
        [vc setCompleteBlock:^(NSString *first, NSString *last) {
            if (completeBlock) {
                completeBlock(first, last);
                XLog_DEBUG(@"选中日期%@------%@", first, last);
            }
        }];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [presentVC presentViewController:nc animated:YES completion:nil];
    }
}

+ (BOOL)compareDateStrWithFirst:(NSString *)first last:(NSString *)last
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kDateFormatter;
    NSDate *firstDate = [dateFormatter dateFromString:first];
    NSDate *lastDate = [dateFormatter dateFromString:last];
    if (!firstDate || !lastDate) {
        XLog_DEBUG(@"date格式不合法");
        return NO;
    }
    return [[NSCalendar currentCalendar] isDate:firstDate equalToDate:lastDate toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
}


@end
