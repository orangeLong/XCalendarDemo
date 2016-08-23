//
//  XCalenderCell.h
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/13.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XCalenderCellStatus) {
    XCalenderCellStatusNormal     = 1 << 0,
    XCalenderCellStatusSelected   = 1 << 1,
    XCalenderCellStatusContained  = 1 << 2,
    XCalenderCellStatusDisabled   = 1 << 3,
};

@interface XCalenderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, assign) XCalenderCellStatus calenderStatus;

@end
