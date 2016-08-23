//
//  XCalenderMonth.m
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/18.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import "XCalenderMonth.h"

@implementation XCalenderMonth


//- (NSInteger)totalCount
//{
//    NSInteger preCount = self.firstWeek + self.days;
//    NSInteger line = preCount / 7;
//    NSInteger spare = preCount % 7;
//    if (spare > 0) {
//        line++;
//    }
//    return line * 7;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.beginDay = 0;
        self.endDay = NSIntegerMax;
    }
    return self;
}

@end
