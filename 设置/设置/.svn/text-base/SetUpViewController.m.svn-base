//
//  SetUpViewController.m
//  iTranslation
//
//  Created by 关旭 on 14-10-10.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import "SetUpViewController.h"
#import "SetUpTableViewCell.h"
#import "LoadingView.h"
#import "APIClient.h"
#import "PopupView.h"
#import "MakeInterface.h"
#import "AboutViewController.h"
#import "ThanksViewController.h"


@interface SetUpViewController ()

@end

@implementation SetUpViewController
{
    //列表
    UITableView *mainTableView;
    //短提示
    PopupView           *popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题栏
    [self createNavgationView];
    //列表
    [self createMainView];
    //提示框
    [self createPopView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 标题栏
- (void)createNavgationView
{
    //背景
    self.view.backgroundColor = GColor(242, 242, 242);
    self.title = @"设置";
    
    
}

#pragma mark - 提示框
- (void)createPopView
{
    popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    popView.ParentView = self.view;
}

#pragma mark - 主视图
- (void)createMainView
{
    //列表
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 420) style:UITableViewStylePlain];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundView = nil;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.scrollEnabled = NO;
    [self.view addSubview:mainTableView];
}


#define kSetUpMenuArray1 @[@"感恩单"]
#define kSetUpMenuArray2 @[@"清空历史记录"]
#define kSetUpMenuArray3 @[@"提点建议",@"赏个好评",@"检测更新",@"关于我们"]

#define kSetUpMenuImageNameArray1 @[@"cell_icon_thank"]
#define kSetUpMenuImageNameArray2 @[@"cell_icon_clear"]
#define kSetUpMenuImageNameArray3 @[@"cell_icon_advice",@"cell_icon_ praise",@"cell_icon_update",@"cell_icon_about"]

#pragma mark -
#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        return kSetUpMenuArray1.count;
    }else if(section == 1){
        return kSetUpMenuArray2.count;
    }else if(section == 2){
        return kSetUpMenuArray3.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //设置section透明
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"SetUpTableViewCell";
    SetUpTableViewCell *cell = (SetUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SetUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    //布局
    if(indexPath.section == 0){
        [cell layoutWithCellIconName:[kSetUpMenuImageNameArray1 objectAtIndex:indexPath.row] CellStr:[kSetUpMenuArray1 objectAtIndex:indexPath.row]];
    }else if(indexPath.section == 1){
        [cell layoutWithCellIconName:[kSetUpMenuImageNameArray2 objectAtIndex:indexPath.row] CellStr:[kSetUpMenuArray2 objectAtIndex:indexPath.row]];
    }else if(indexPath.section == 2){
        [cell layoutWithCellIconName:[kSetUpMenuImageNameArray3 objectAtIndex:indexPath.row] CellStr:[kSetUpMenuArray3 objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            //感恩单
            [self pushThanks];
            break;
        case 1:
            //清空记录
            [self clearTranslate];
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    //提点建议
                    [self takeAdvice];
                    break;
                case 1:
                    //赏个好评
                    [self highPraise];
                    break;
                case 2:
                    //检测更新
                    [self checkVersion];
                    break;
                case 3:
                    //关于
                    [self pushAbout];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

#pragma mark - 感恩单
- (void)pushThanks
{
    ThanksViewController *thanksView = [[ThanksViewController alloc] init];
    [self.navigationController pushViewController:thanksView animated:YES];
}

#pragma mark - 清空记录
- (void)clearTranslate
{
    //查看是否有翻译记录
    NSData *savedTranslteList = [MakeInterface getAsynchronousWithKey:@"翻译记录"];
    if(savedTranslteList == nil){
        [self.view addSubview:popView];
        [popView setText:@"没有翻译记录"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要删除所有保存的翻译记录么？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 0;
        [alert show];
    }
    
    
}

#pragma mark - 提点建议
- (void)takeAdvice
{
    [[LoadingView sharedLoadingView] loadingViewInView:self.view];
    //发送邮件
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    [mailCompose setMailComposeDelegate:self];
    //设置收件人
    [mailCompose setToRecipients:MAIL_RECIPITENTS];
    //设置邮件主题
    [mailCompose setSubject:MAIL_SUBJECT];
    //设置邮件内容
    [mailCompose setMessageBody:MAIL_BODY isHTML:NO];
    
    [self.navigationController presentViewController:mailCompose animated:YES completion:^{
        [[LoadingView sharedLoadingView] removeView];
    }];
}

#pragma mark - 赏个好评
- (void)highPraise
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - 检测更新
- (void)checkVersion
{
    [[LoadingView sharedLoadingView] loadingViewInView:self.view];
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=cn",APP_ID];
    //请求
    [[APIClient sharedClient] requestPath:url
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id JSON)
     //成功回调
     {
         //解析数据
         if (![JSON isKindOfClass:[NSDictionary class]]){
             GLog(@"数据类型错误！");
             [[LoadingView sharedLoadingView] removeView];
             return ;
         }
         if(![JSON objectForKey:@"error_code"]){
             GLog(@"接口请求成功!");
             NSArray *results = [JSON objectForKey:@"results"];
             //数据格式错误
             if (![results isKindOfClass:[NSArray class]] || [results count] == 0){
                 GLog(@"数据格式错误!");
                 //联网结束
                 [[LoadingView sharedLoadingView] removeView];
                 return ;
             }
             //解析
             NSString *appStoreVersion = [[results objectAtIndex:0] objectForKey:@"version"];
             NSString *releaseNotes = [[results objectAtIndex:0] objectForKey:@"releaseNotes"];
             //检测更新
             if([MakeInterface checkVresionWithAppStoreVersion:appStoreVersion CurrentVresion:VERSION]){
                 //提示更新
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                 message:releaseNotes
                                                                delegate:self
                                                       cancelButtonTitle:@"一会再说"
                                                       otherButtonTitles:@"立即更新",nil];
                 alert.tag = 1;
                 [alert show];
             }else{
                 //未发现新版本
                 [self.view addSubview:popView];
                 [popView setText:@"未发现新版本"];
             }
         }else{
             [self.view addSubview:popView];
             [popView setText:@"网络有问题了"];
         }
         //联网结束
         [[LoadingView sharedLoadingView] removeView];
         
     }
     //失败回调
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.view addSubview:popView];
         [popView setText:@"网络有问题了"];
         //联网结束
         [[LoadingView sharedLoadingView] removeView];
     }];
    
    
}

#pragma mark - 关于
- (void)pushAbout
{
    AboutViewController *aboutView = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutView animated:YES];
}

#pragma mark -
#pragma mark - alertView degelate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //清空翻译记录
    if(alertView.tag == 0){
        if(buttonIndex == 1){
            [MakeInterface clearAsynchronousWithKey:@"翻译记录"];
            [self.view addSubview:popView];
            [popView setText:@"已删除所有翻译记录"];
        }
    }
    //更新新版本
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/zhong-cai-piao/id%@?ls=1&mt=8",APP_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}


#pragma mark - 
#pragma mark - MFMailComposeViewController Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *mailMsg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            mailMsg = @"已取消";
            break;
        case MFMailComposeResultSaved:
            mailMsg = @"已保存";
            break;
        case MFMailComposeResultSent:
            mailMsg = @"发送成功，我们会认真考虑您的建议并第一时间回复您";
            break;
        case MFMailComposeResultFailed:
            mailMsg = @"发送失败,请重试";
            break;
        default:
            break;
    }
    //提示用户
    [self dismissViewControllerAnimated:YES completion:^{
        [self.view addSubview:popView];
        [popView setText:mailMsg];
    }];
}


@end
