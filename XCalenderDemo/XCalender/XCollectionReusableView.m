//
//  XCollectionReusableView.m
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/14.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import "XCollectionReusableView.h"

#import "XCalenderDefine.h"

@interface XCollectionReusableView ()

@property (nonatomic, strong) UIView *lineView; /**< 横线*/

@end

@implementation XCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.font = [UIFont systemFontOfSize:14.f];
        self.monthLabel.textColor = XCalender_RGB(0, 122, 255);
        [self addSubview:self.monthLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineView.backgroundColor = XCalender_RGB(240, 240, 240);
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)updateFrameWith:(NSInteger)position totalPostion:(NSInteger)total
{
    CGFloat singleWidth = self.frame.size.width / total;
    self.monthLabel.frame = CGRectMake(singleWidth * position, 0, singleWidth, self.frame.size.height);
    self.lineView.frame = CGRectMake(singleWidth * position, self.frame.size.height - 10.5, self.frame.size.width - singleWidth * position, 0.5);
}

@end
