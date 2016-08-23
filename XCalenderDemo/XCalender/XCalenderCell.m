//
//  XCalenderCell.m
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/13.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import "XCalenderCell.h"

#import "XCalenderDefine.h"

#define XCalender_ContainedColor  XCalender_RGB(239, 248, 255)
#define XCalender_DisabledColor  XCalender_RGB(200, 199, 204)
#define XCalender_SelectedColor  XCalender_RGB(0, 122, 255)

@implementation XCalenderCell

- (void)awakeFromNib {
    self.dateLabel.layer.masksToBounds = YES;
}

- (void)setCalenderStatus:(XCalenderCellStatus)calenderStatus
{
    if (calenderStatus != _calenderStatus) {
        _calenderStatus = calenderStatus;
        if (calenderStatus & XCalenderCellStatusNormal) {
            self.dateLabel.textColor = [UIColor blackColor];
            self.dateLabel.backgroundColor = [UIColor whiteColor];
        }
        if (calenderStatus & XCalenderCellStatusContained) {
            self.dateLabel.textColor = [UIColor blackColor];
            self.dateLabel.backgroundColor = XCalender_ContainedColor;
            self.backgroundColor = XCalender_ContainedColor;
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
        if (calenderStatus & XCalenderCellStatusSelected) {
            self.dateLabel.textColor = [UIColor whiteColor];
            self.dateLabel.backgroundColor = XCalender_SelectedColor;
            self.dateLabel.layer.cornerRadius = self.dateLabel.frame.size.width / 2;
        }
        if (calenderStatus & XCalenderCellStatusDisabled) {
            self.dateLabel.textColor = XCalender_DisabledColor;
            self.dateLabel.backgroundColor = [UIColor whiteColor];
        }
    }
}



@end
