//
//  DropDownMenuView.m
//  DropDown_Menu
//
//  Created by Geraint on 2018/11/21.
//  Copyright © 2018 kilolumen. All rights reserved.
//

#import "DropDownMenuView.h"


//#define AnimateTime 0.25f    // 没有信息类型，并且在预处理过程中会把碰到的所有AnimateTime一律换成0.25f

static const NSTimeInterval kAnimateTime = 0.25f;  // 下拉动画时间（这样写就好）

//@interface DropDownMenuView ()
//
//@property (nonatomic, strong) UIImageView *arrowMark;
//@property (nonatomic, strong) UIView *listView;
//
//@end

@implementation DropDownMenuView
{
    UIImageView * _arrowMark;        // 箭头图标
    UIView * _listView;              // 下拉菜单背景view
    UITableView * _tableView;        // 下拉列表
    
    NSArray * _titleArray;           // 选项数组
    CGFloat  _rowHeight;             // 下拉列表行高
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainButtonWithFrame:frame];
    }
    return self;
}

// 重写 setframe 方法
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self createMainButtonWithFrame:frame];
}

- (void)createMainButtonWithFrame:(CGRect)frame {
    
    [_mainButton removeFromSuperview];
    _mainButton = nil;
    
    // 主按钮 显示在界面上的点击按钮
    // custom 样式
    _mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mainButton setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mainButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_mainButton addTarget:self action:@selector(clickMainButton:) forControlEvents:UIControlEventTouchUpInside];
    _mainButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; // 控件内定位，默认中心,在这里靠近左侧
    _mainButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _mainButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _mainButton.selected = NO;
    _mainButton.backgroundColor = [UIColor whiteColor];
    _mainButton.layer.borderColor = [UIColor blackColor].CGColor; // 图层边框的颜色
    _mainButton.layer.borderWidth = 1;  // 图层边框的宽度
    
    [self addSubview:_mainButton];
    
    
    // 箭头
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(_mainButton.frame.size.width-15, 0, 9, 9)];
    _arrowMark.center = CGPointMake(_arrowMark.center.x, _mainButton.frame.size.height/2);
    _arrowMark.image = [UIImage imageNamed:@"dropdownMenu_cornerIcon.png"];
    [_mainButton addSubview:_arrowMark];
    
}


// 设置下拉菜单控件的样式
- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight {
    if (self == nil) {
        return;
    }
    
    _titleArray = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;
    
    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
    _listView.clipsToBounds = YES; // When YES, content and subviews are clipped to the bounds of the view. Default is NO.
    _listView.layer.masksToBounds = NO; // 默认为NO，在这里可以省略不写
    _listView.layer.borderColor = [UIColor lightGrayColor].CGColor;  // 图层边框的颜色
    _listView.layer.borderWidth = 0.5f;  // 图层边框的宽度
    
    // 下拉列表Tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _listView.frame.size.width, _listView.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [_listView addSubview:_tableView];
    
}

// 点击事件
- (void)clickMainButton:(UIButton *)button {
    
    [self.superview addSubview:_listView]; // 将下拉视图添加到控件的父视图上
    
    if (button.selected == NO) {
        [self showDropDown];
    } else {
        [self hideDropDown];
    }
}

#pragma mark -- 显示下拉列表
// 在这个方法中调用  代理方法
- (void)showDropDown {    // 显示下拉列表
    [_listView.superview bringSubviewToFront:_listView];  // 将下拉列表置于最上层
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {   // 判断是否实现了某方法
        [self.delegate dropdownMenuWillShow:self];  // 将要显示回调代理
    }
    
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        _listView.frame = CGRectMake(_listView.frame.origin.x, _listView.frame.origin.y, _listView.frame.size.width, _rowHeight * _titleArray.count);
        _tableView.frame = CGRectMake(0, 0, _listView.frame.size.width, _listView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
            [self.delegate dropdownMenuDidShow:self];   // 已经显示回调代理
        }
    }];
    
    _mainButton.selected = YES;  // 控件是否为选定状态
}

#pragma mark -- 隐藏下拉列表
- (void)hideDropDown {
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHidden:)]) {  // 判断是否实现的某方法
        [self.delegate dropdownMenuWillHidden:self];  // 将要隐藏回调代理
    }
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformIdentity;  // 身份变换
        _listView.frame = CGRectMake(_listView.frame.origin.x, _listView.frame.origin.y, _listView.frame.size.width, 0);
        _tableView.frame = CGRectMake(0, 0, _listView.frame.size.width, _listView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHidden:)]) {
            [self.delegate dropdownMenuDidHidden:self];  // 已经隐藏回调代理
        }
    }];
    _mainButton.selected = NO;
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        // -------------------------  下拉选项样式，可在此处自定义  --------------------
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:11.f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight - 0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [cell addSubview:line];
        
        // ------------------------------------------------------------------------
    }
    
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_mainButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellNumber:)]) {
        [self.delegate dropdownMenu:self selectedCellNumber:indexPath.row];   // 回调代理
        
    }
    [self hideDropDown];
}

@end

