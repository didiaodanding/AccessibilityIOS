//
//  ACCViewController.m
//  AccessibilityIOS
//
//  Created by haleli on 08/02/2021.
//  Copyright (c) 2021 haleli. All rights reserved.
//

#import "ACCViewController.h"
#import "UIColor+Utils.h"
#import "UIView+Tree.h"
#import "UIView-Debugging.h"

static NSString *const kCellID = @"cellID";

@interface ACCViewController ()

@property (nonatomic , strong , nonnull) UITableView *tableView;

@end

@implementation ACCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpTableView];
    
    self.view.backgroundColor =  [UIColor colorWithWhite:0.95 alpha:1];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // To Control subviews.
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGFLOAT_MIN)];
    self.tableView.backgroundColor =  [UIColor colorWithWhite:0.95 alpha:1];
    [self.tableView setSeparatorColor:[UIColor darkTextColor]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = nil;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"测试颜色对比度";
    }else if(indexPath.section == 1){
        cell.textLabel.text = @"测试字体小于18";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }else if(indexPath.section == 2){
        cell.textLabel.text = @"测试不含英文单词、数字、符号的任意两种混合";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView printViewHierarchy];
    if (indexPath.section == 0) {
        CGFloat contrasRatio1 = [UIColor contrastRatio:[UIColor blackColor] between:[UIColor whiteColor]];
        NSLog(@"颜色对比度：%f",contrasRatio1);
        CGFloat contrastRatio2 = [[UIColor blackColor] contrastRatioWithColor: [UIColor whiteColor]];
        NSLog(@"颜色对比度:%f",contrastRatio2);
    }else if(indexPath.section ==1){
        [UIView tree];
    }else if(indexPath.section ==2){
        [UIView tree];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"颜色对比度";
    }else if(section == 1){
        return @"字体小于18";
    }else if(section == 2){
        return @"不含英文单词数字符号的任意两种混合";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 设置section背景颜色
    view.tintColor = [UIColor groupTableViewBackgroundColor];
    
    // 设置section字体颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:18];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
