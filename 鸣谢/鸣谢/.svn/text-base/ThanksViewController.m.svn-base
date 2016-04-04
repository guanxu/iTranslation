//
//  ThanksViewController.m
//  iTranslation
//
//  Created by 关旭 on 14-10-11.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import "ThanksViewController.h"
#import "ThanksTableViewCell.h"
#import "MakeInterface.h"

@interface ThanksViewController ()

@end

@implementation ThanksViewController
{
    UITableView *mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GColor(242, 242, 242);
    self.title = @"特别鸣谢";
    
    UILabel *topLabel = [MakeInterface createCommonLabelWithFrame:CGRectMake(20, 80, self.view.frame.size.width-40, 80)];
    topLabel.textColor = GColor(33, 33, 33);
    topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    topLabel.numberOfLines = 0;
    topLabel.text = @"特别鸣谢以下用户为iTranslate提出的宝贵意见与建议,我们都已采纳并将之加入到研发环节,部分内容已经研发成功并在新版本中展示。";
    [self.view addSubview:topLabel];
    
    //鸣谢人列表
    [self createMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#define kPersionList @[@"vigoss@sina.com",@"323232@qq.com"]
#pragma mark - 主视图
- (void)createMainView
{
    //列表
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 180, self.view.frame.size.width-40, self.view.frame.size.height) style:UITableViewStylePlain];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundView = nil;
    mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainTableView];
    
}

#pragma mark -
#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kPersionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ThanksTableViewCell";
    ThanksTableViewCell *cell = (ThanksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ThanksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    [cell layoutWithCellStr:[kPersionList objectAtIndex:indexPath.row]];
    return cell;
}

@end
