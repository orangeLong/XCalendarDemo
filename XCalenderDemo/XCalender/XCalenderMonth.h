//
//  XCalenderMonth.h
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/18.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCalenderMonth : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger days;

@property (nonatomic, assign) NSInteger firstWeek;
@property (nonatomic, assign) NSInteger beginDay; /**< 开始时间  之前不可选中*/
@property (nonatomic, assign) NSInteger endDay;   /**< 结束时间 之后不可选中*/

@property (nonatomic, assign) NSInteger totalCount;


@end
