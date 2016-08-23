//
//  XCollectionReusableView.h
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/14.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *monthLabel; /**< 月份*/

- (void)updateFrameWith:(NSInteger)position totalPostion:(NSInteger)total;

@end
