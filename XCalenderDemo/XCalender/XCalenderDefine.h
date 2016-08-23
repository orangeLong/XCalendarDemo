//
//  XCalenderDefine.h
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/19.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#ifndef XCalenderDefine_h
#define XCalenderDefine_h

#if Debug
    #define XLog_DEBUG(format, ...)    NSLog(@"[DEBUG] {%s,%d} " format, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define XLog_DEBUG(format, ...)
#endif

#define XCalender_RGB(A, B, C) [UIColor colorWithRed:A / 255.0 green:B / 255.0 blue:C / 255.0 alpha:1.0]
#define OriginDateStr @"2010-01-01 08:00:00"
#define kDateFormatter @"yyyy-MM-dd HH:mm:ss"

#endif /* XCalenderDefine_h */
