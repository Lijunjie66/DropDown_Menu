//
//  DropDownMenuView.h
//  DropDown_Menu
//
//  Created by Geraint on 2018/11/21.
//  Copyright © 2018 kilolumen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class DropDownMenuView;  // 因为在创建的代理中 把这个 类 做参数，所以在之前使用：【向前声明,以导入这个类】

@protocol DropDownMenuDelegate <NSObject>

- (void)dropdownMenuWillShow:(DropDownMenuView *)menu;      // 当下拉菜单将要显示时调用
- (void)dropdownMenuDidShow:(DropDownMenuView *)menu;       // 当下拉菜单已经显示时调用
- (void)dropdownMenuWillHidden:(DropDownMenuView *)menu;    // 当下拉菜单将要收起时调用
- (void)dropdownMenuDidHidden:(DropDownMenuView *)menu;     // 当下拉菜单已经收起时调用

- (void)dropdownMenu:(DropDownMenuView *)menu selectedCellNumber:(NSInteger)number;  // 当选择某个选项时调用

@end


@interface DropDownMenuView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *mainButton;   // 主按钮，可以自定义样式，可以在.m 文件中修改默认的一些属性

/* 代理 */
@property (nonatomic, assign) id <DropDownMenuDelegate>delegate;

/* 下拉列表中的选项标题以及选项高度的设置 */
- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight; // 设置下拉菜单控件的样式

- (void)showDropDown;   // 显示下拉菜单
- (void)hideDropDown;   // 隐藏下拉菜单


@end

NS_ASSUME_NONNULL_END
