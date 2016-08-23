//
//  XCalenderView.m
//  XCalenderDemo
//
//  Created by LiX i n long on 16/7/12.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import "XCalenderView.h"

#import "XCalenderDefine.h"

#import "XCalenderCell.h"
#import "XCollectionReusableView.h"

#import "XCalenderMonth.h"

#define kConfirmHeight 44.f
#define kMonthHeight 34.f
#define dateBtnTag 300

@interface XCalenderView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat controlWidth; /**< 星期view宽度*/

@property (nonatomic, strong) NSCalendar *currentCalender; /**< 当前日历*/

@property (nonatomic, strong) UICollectionView *collectionView; /**< */
@property (nonatomic, strong) UIButton *confirmBtn; /**< 确认按钮*/
@property (nonatomic, strong) NSMutableArray *allMonths; /**< */
@property (nonatomic, strong) NSMutableArray *superArray; /**< 牛逼的array*/

@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*selectedArray; /**< 选中的indexPtah*/

@end

@implementation XCalenderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString *cellIndentifier = @"calenderCell";
static NSString *sectionIndentifier = @"calenderSection";

#pragma mark - initView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatasource];
        [self initHeaderView];
        [self initCollectionView];
        [self initConfirmButton];
    }
    return self;
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kMonthHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderColor = XCalender_RGB(240, 240, 240).CGColor;
    headerView.layer.borderWidth = 0.5;
    [self addSubview:headerView];
    NSArray *weekArray = self.currentCalender.shortWeekdaySymbols;
    for (int i = 0; i < weekArray.count; i++) {
        NSString *weekStr = weekArray[i];
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * self.controlWidth, 0, self.controlWidth, kMonthHeight)];
        weekLabel.font = [UIFont systemFontOfSize:10.f];
        weekLabel.textColor = XCalender_RGB(133, 133, 133);
        weekLabel.text = weekStr;
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:weekLabel];
    }
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 17;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMonthHeight, self.frame.size.width, self.frame.size.height - kConfirmHeight - kMonthHeight) collectionViewLayout:flowLayout];
    collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XCalenderSource" ofType:@"bundle"];
    NSBundle *customBundle = [NSBundle bundleWithPath:bundlePath];
    [collectionView registerNib:[UINib nibWithNibName:@"XCalenderCell" bundle:customBundle] forCellWithReuseIdentifier:cellIndentifier];
    [collectionView registerClass:[XCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionIndentifier];
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.allMonths.count - 1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)initConfirmButton
{
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(0, self.frame.size.height - kConfirmHeight, self.frame.size.width, kConfirmHeight);
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.confirmBtn setBackgroundColor:XCalender_RGB(71, 159, 255)];
    [self.confirmBtn setBackgroundImage:[self imageWithName:@"button_blue_enable"] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[self imageWithName:@"button_diable"] forState:UIControlStateDisabled];
    self.confirmBtn.enabled = NO;
    [self.confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmBtn];
}

- (UIImage *)imageWithName:(NSString *)imageName
{
    NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"XCalenderSource.bundle"];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:imageName]];
    return image;
}

#pragma mark - initDataSource
/**
 *  初始化相关数据
 */
- (void)initDatasource
{
    self.currentCalender = [NSCalendar currentCalendar];
    [self resetDataSource:self.startDate];
    self.selectedArray = [NSMutableArray array];
    NSInteger width = (NSInteger)(self.frame.size.width / 7.0 * 10);
    NSInteger spare = (NSInteger)width % 5;
    self.controlWidth = (width - spare) / 10.0;
    self.dateSpace = NSUIntegerMax;
}

#pragma mark - private
/**
 *  把选中的indexpath添加到数组中并排好序
 *
 *  @param indexPath
 */
- (void)addIndexPathToSelectedArray:(NSIndexPath *)indexPath
{
    if (self.selectedArray.count == 1) {
        NSIndexPath *first = [self.selectedArray firstObject];
        if (indexPath.section > first.section) {
            [self.selectedArray addObject:indexPath];
        } else if (indexPath.section == first.section) {
            if (indexPath.row > first.row) {
                [self.selectedArray addObject:indexPath];
            } else if (indexPath.row < first.row) {
                [self.selectedArray insertObject:indexPath atIndex:0];
            }
        } else {
            [self.selectedArray insertObject:indexPath atIndex:0];
        }
    } else if (self.selectedArray.count == 2) {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:indexPath];
    } else {
        [self.selectedArray addObject:indexPath];
    }
}

/**
 *  通过indexpath找到对应的天
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)getDayWithIndexPath:(NSIndexPath *)indexPath
{
    XCalenderMonth *month = self.superArray[indexPath.section];
    NSInteger day = indexPath.row - month.firstWeek + 1;
    if (day > 0 && day <= month.days) {
        return day;
    }
    return 0;
}
/**
 *  通过indexpath获取相关日期
 *
 *  @param indexPath
 *
 *  @return 空白处返回nil
 */
- (NSDateComponents *)componentsFromIndexpath:(NSIndexPath *)indexPath
{
    XCalenderMonth *month = self.superArray[indexPath.section];
    NSInteger day = indexPath.row - month.firstWeek + 1;
    if (day > 0 && day <= month.days) {
        NSDateComponents *dateCom = [[NSDateComponents alloc] init];
        dateCom.year = month.year;
        dateCom.month = month.month;
        dateCom.day = day;
        return dateCom;
    }
    return nil;
}

/**
 *  通过indexpath返回cell的相关状态用于刷新
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (XCalenderCellStatus)calenderCellStatusFromIndexPath:(NSIndexPath *)indexPath
{
    XCalenderCellStatus status = XCalenderCellStatusNormal;
    if (self.selectedArray.count == 2) {
        NSIndexPath *first = [self.selectedArray firstObject];
        NSIndexPath *last = [self.selectedArray lastObject];
        if ([indexPath isEqual:first] || [indexPath isEqual:last]) {
            status = XCalenderCellStatusSelected | XCalenderCellStatusContained;
        } else {
            BOOL isContain = NO;
            if (first.section != last.section) {
                BOOL sectionContain = indexPath.section > first.section && indexPath.section < last.section;
                BOOL firstContain = indexPath.section == first.section && indexPath.row > first.row;
                BOOL lastContain = indexPath.section == last.section && indexPath.row < last.row;
                isContain = sectionContain || firstContain || lastContain;
            } else {
                if (indexPath.section == first.section) {
                    isContain = indexPath.row > first.row && indexPath.row < last.row;
                }
            }
            if (isContain) {
                status = XCalenderCellStatusContained;
            }
        }
    } else if (self.selectedArray.count == 1) {
        NSIndexPath *first = [self.selectedArray firstObject];
        if ([indexPath isEqual:first]) {
            status = XCalenderCellStatusSelected;
        }
    }
    return status;
}
/**
 *  初始化数据源
 *
 *  @param startDate 开始时间
 */
- (void)resetDataSource:(NSDate *)startDate
{
    NSMutableArray *allMonths = [NSMutableArray array];
    NSDate *endDate = [NSDate date];
    NSDateComponents *dateComponents = [self dateComponentFromStartDate:startDate endDate:endDate];
    for (int i = 0; i < dateComponents.month + 1 + dateComponents.year * 12; i++) {
        NSDate *date = [self.currentCalender dateByAddingUnit:NSCalendarUnitMonth value:i toDate:startDate options:0];
        [allMonths addObject:date];
    }
    self.allMonths = allMonths;
    
    NSDateComponents *startCom = [self dateComponentsWithDate:startDate];
    NSDateComponents *endCom = [self dateComponentsWithDate:endDate];
    
    NSDateComponents *lastCom = [self dateComponentsWithDate:[allMonths lastObject]];
    if (endCom.month == lastCom.month + 1) {
        [allMonths addObject:endDate];
    }
    NSMutableArray *bigArray = [NSMutableArray array];
    for (NSDate *eachMonth in allMonths) {
        XCalenderMonth *month = [self calenderWithdate:eachMonth];
        if (month.year == startCom.year && month.month == startCom.month) {
            month.beginDay = startCom.day;
        }
        if (month.year == endCom.year && month.month == endCom.month) {
            month.endDay = endCom.day - 1;//当前天也不可点 如需可点 去掉-1即可
            [self setTotalCount:month days:endCom.day];
        }
        [bigArray addObject:month];
    }
    self.superArray = bigArray;
}

- (void)setTotalCount:(XCalenderMonth *)month days:(NSInteger)days
{
    NSInteger preCount = month.firstWeek + days;
    NSInteger line = preCount / 7;
    NSInteger spare = preCount % 7;
    if (spare > 0) {
        line++;
    }
    month.totalCount = line * 7;
}

/**
 *  根据当前月解析成相关对象
 *
 *  @param eachMonth 每个月的日期
 *
 *  @return
 */
- (XCalenderMonth *)calenderWithdate:(NSDate *)eachMonth
{
    NSDateComponents *dateComponents = [self dateComponentsWithDate:eachMonth];
   
    XCalenderMonth *month = [[XCalenderMonth alloc] init];
    month.year = dateComponents.year;
    month.month = dateComponents.month;
    month.days = [self totaldaysInThisMonth:eachMonth];
    month.firstWeek = [self firstWeekdayInThisMonth:eachMonth];
    [self setTotalCount:month days:month.days];
    return month;
}

/**
 *  判断选中的两个时间间隔是否小于等于设置值
 *
 *  @param indexPath 第二次选中的indexpath
 *
 *  @return
 */
- (BOOL)judgeTwoDaySpace:(NSDateComponents *)dateComponents
{
    if (self.selectedArray.count == 1) {
        NSIndexPath *firstIndex = [self.selectedArray firstObject];
        NSDateComponents *firstDateCom = [self componentsFromIndexpath:firstIndex];
        NSDateComponents *compareCom = [self.currentCalender components:NSCalendarUnitDay fromDateComponents:firstDateCom toDateComponents:dateComponents options:0];
        if (labs(compareCom.day) >= self.dateSpace) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - action
/**
 *  点击确认
 *
 *  @param button <#button description#>
 */
- (void)confirmClick:(UIButton *)button
{
    if (self.confirmBlock) {
        NSIndexPath *first = [self.selectedArray firstObject];
        NSIndexPath *last = [self.selectedArray lastObject];
        NSString *firstStr = [self getDateFromIndexPath:first isStartDate:YES];
        NSString *lastStr = [self getDateFromIndexPath:last isStartDate:NO];
        self.confirmBlock(firstStr, lastStr);
    }
}
/**
 *  通过选中的indexpath 返回相应的时间字符串
 *
 *  @param indexPath <#indexPath description#>
 *  @param isStart   是否是开始时间
 *
 *  @return 格式化的时间字符串
 */
- (NSString *)getDateFromIndexPath:(NSIndexPath *)indexPath isStartDate:(BOOL)isStart
{
    XCalenderMonth *month = self.superArray[indexPath.section];
    NSInteger day = indexPath.row - month.firstWeek + 1;
    NSString *suffix = @"23:59:59";
    if (isStart) {
        suffix = @"00:00:00";
    }
    return [NSString stringWithFormat:@"%zi-%zi-%zi %@", month.year, month.month, day, suffix];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 7 == 0) {
        CGFloat spare = self.frame.size.width - self.controlWidth * 7;
        return CGSizeMake(self.controlWidth + spare, self.controlWidth);
    }
    return CGSizeMake(self.controlWidth, self.controlWidth);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.superArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XCalenderMonth *month = self.superArray[section];
    return month.totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    NSString *dayStr = nil;
    XCalenderMonth *month = self.superArray[indexPath.section];
    NSInteger day = indexPath.row - month.firstWeek + 1;
    if (day > 0 && day <= month.days) {
        dayStr = [NSString stringWithFormat:@"%zi", day];
    }
    if (day > 0 && (month.beginDay > day || month.endDay < day)) {
        cell.calenderStatus = XCalenderCellStatusDisabled;
    } else {
        cell.calenderStatus = [self calenderCellStatusFromIndexPath:indexPath];
    }
    cell.dateLabel.text = dayStr;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 80);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionIndentifier forIndexPath:indexPath];
        XCalenderMonth *month = self.superArray[indexPath.section];
        reusableView.monthLabel.text = [NSString stringWithFormat:@"%zi月", month.month];
        [reusableView updateFrameWith:month.firstWeek totalPostion:7];
        return reusableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *dateComponents = [self componentsFromIndexpath:indexPath];
    //点击空白处return掉
    if (!dateComponents) {
        return;
    }
    XCalenderMonth *month = self.superArray[indexPath.section];
    //置灰出、处return
    if (month.beginDay > dateComponents.day || month.endDay < dateComponents.day) {
        return;
    } else {
        if ([self judgeTwoDaySpace:dateComponents]) {
            [self addIndexPathToSelectedArray:indexPath];
            self.confirmBtn.enabled = self.selectedArray.count > 0;
            [collectionView reloadData];
        } else {
            NSString *string = [NSString stringWithFormat:@"目前统计最多只支持%zi天", self.dateSpace];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        }
    }
}

#pragma mark - date
/**
 *  这个月有几天
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)totaldaysInThisMonth:(NSDate *)date
{
    NSRange totaldaysInMonth = [self.currentCalender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}
/**
 *  当月第一天是星期几
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date
{
    NSCalendar *calendar = self.currentCalender;
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/**
 *  获取当年时间相关
 *
 *  @param date 
 *
 *  @return <#return value description#>
 */
- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    return dateComponents;
}

/**
 *  获取两个时间内的时间信息，如果获取当年信息可以不传 
 *
 *  @param startDate 起始时间
 *  @param endDate   结束时间
 *
 *  @return <#return value description#>
 */
- (NSDateComponents *)dateComponentFromStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendarUnit type =
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitWeekday;
    NSCalendar *calendar = self.currentCalender;
    if (!endDate) {
        endDate = [NSDate date];
    }
    if (startDate) {
        return [calendar components:type fromDate:startDate toDate:endDate options:NSCalendarWrapComponents];
    } else {
        return [calendar components:type fromDate:endDate];
    }
}

#pragma mark - getter && setter

@synthesize startDate = _startDate;

- (void)setStartDate:(NSDate *)startDate
{
    if (_startDate != startDate) {
        _startDate = startDate;
        [self resetDataSource:startDate];
    }
}

- (NSDate *)startDate
{
    if (!_startDate) {
        NSString *startStr = OriginDateStr;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kDateFormatter;
        //        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.locale = [NSLocale currentLocale];
        _startDate = [dateFormatter dateFromString:startStr];
    }
    return _startDate;
}

@end
