//
//  ViewController.m
//  DropDown_Menu
//
//  Created by Geraint on 2018/11/21.
//  Copyright © 2018 kilolumen. All rights reserved.
//

#import "ViewController.h"
#import "DropDownMenuView.h"

@interface ViewController () <DropDownMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 控件的设置
    DropDownMenuView *dropDownMenuView = [[DropDownMenuView alloc] init];
    [dropDownMenuView setFrame:CGRectMake(20, 80, 100, 40)];
    [dropDownMenuView setMenuTitles:@[@"选项一",@"选项二",@"选项三",@"选项四", @"无"] rowHeight:30];
    dropDownMenuView.delegate = self;
    [self.view addSubview:dropDownMenuView];
    
    
}

#pragma mark -- DropDownMenuView Delegate
// 当选择某个选项时调用
- (void)dropdownMenu:(DropDownMenuView *)menu selectedCellNumber:(NSInteger)number {
    NSLog(@"当选择某个选项时调用,--- 你选择了：%ld", number);
}

- (void)dropdownMenuWillShow:(DropDownMenuView *)menu {
    NSLog(@"-- 将要显示 --");
}

- (void)dropdownMenuDidShow:(DropDownMenuView *)menu {
    NSLog(@"-- 已经显示 --");
}

- (void)dropdownMenuWillHidden:(DropDownMenuView *)menu {
    NSLog(@"-- 将要隐藏 --");
}

- (void)dropdownMenuDidHidden:(DropDownMenuView *)menu {
    NSLog(@"-- 已经隐藏 --");
}
@end
