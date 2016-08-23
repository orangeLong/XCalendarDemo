//
//  XCalenderViewController.m
//  MobileCashier
//
//  Created by LiX i n long on 16/7/26.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XCalenderViewController.h"

#import "XCalenderView.h"
#import "UIBarButtonItem+Style.h"

@interface XCalenderViewController ()

@end

@implementation XCalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自定义";
    [self addDeleteBarButton];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addDeleteBarButton
{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *button = [UIBarButtonItem barButtonItemWithImageName:@"close" target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)initView
{
    XCalenderView *calenderView = [[XCalenderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    calenderView.dateSpace = 30;
    [self.view addSubview:calenderView];
    WeakSelf(weakSelf);
    [calenderView setConfirmBlock:^(NSString *first, NSString *last) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        if (strongSelf.completeBlock) {
            strongSelf.completeBlock(first, last);
        }
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.completeBlock) {
        self.completeBlock(nil, nil);
    }
}

@end
