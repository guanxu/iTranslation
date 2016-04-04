//
//  MakeInterface.m
//  iTranslation
//
//  Created by 关 旭 on 14-9-27.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import "MakeInterface.h"

@implementation MakeInterface

#pragma mark - 创建UILabel
+ (UILabel *)createCommonLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Arial" size:14]];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - 创建UIButton
+ (UIButton *)createCommonButtonWithFrame:(CGRect)frame
                                      tag:(int)tag
                                   target:(id)target
                                 selector:(SEL)selector

{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 隐藏键盘按钮
+ (UIButton *) hideKeyboardBtnWithTarget:(id)target Selector:(SEL)selector{
    UIButton *hideKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(320-57, 480+(iPhone5?88:0), 55, 27)];
    [hideKeyboardBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [hideKeyboardBtn setImage:[UIImage imageNamed:@"hide_keyboard"] forState:UIControlStateNormal];
    return hideKeyboardBtn;
}

#pragma mark - 画线
+(UIImageView *)drawLineWithFrame:(CGRect)frame
{
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:frame];
    lineImageView.image = [UIImage imageNamed:@"line"];
    return lineImageView;
}

#pragma mark - 导航栏右侧按钮
+(UIButton *)createRightBtnWithImageName:(NSString *)imageName
                              Target:(id)target
                             selector:(SEL)selector
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(300, 0, 30, 30);
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

#pragma mark 比较app得版本号跟当前版本号高低
+ (BOOL)checkVresionWithAppStoreVersion:(NSString *)appStoreVresion CurrentVresion:(NSString *)currentVresion{
    NSMutableArray * appStoreVersionArray = (NSMutableArray *)[appStoreVresion componentsSeparatedByString:@"."];
    NSMutableArray * currentVersionArray = (NSMutableArray *)[currentVresion componentsSeparatedByString:@"."];
    //防止1.1.1跟1.1比较数组没有第三个值崩溃
    if([appStoreVersionArray count]==2){
        [appStoreVersionArray addObject:@"0"];
    }
    if([currentVersionArray count]==2){
        [currentVersionArray addObject:@"0"];
    }
    if([[appStoreVersionArray objectAtIndex:0] intValue]>[[currentVersionArray objectAtIndex:0] intValue]){
        //如果app版本第一位比当前版本第一位大 直接提示更新
        return YES;
    }else if ([[appStoreVersionArray objectAtIndex:0] intValue] == [[currentVersionArray objectAtIndex:0] intValue]){
        //如果第一位相等 那么比较下一位
        if ([[appStoreVersionArray objectAtIndex:1] intValue]>[[currentVersionArray objectAtIndex:1] intValue]){
            //如果app版本第二位比当前版本第二位大 提示更新
            return YES;
        }else if([[appStoreVersionArray objectAtIndex:1] intValue]==[[currentVersionArray objectAtIndex:1] intValue]){
            //如果app版本第三位比当前版本第三位大 提示更新
            if ([[appStoreVersionArray objectAtIndex:2] intValue]>[[currentVersionArray objectAtIndex:2] intValue]){
                return YES;
            }
        }
    }
    //其余情况都是NO
    return NO;
}

#pragma mark - 持久化保存
+ (void)setAsynchronous:(id)object WithKey:(NSString *)key
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info setObject:object forKey:key];
    [info synchronize];
}
+ (void)clearAsynchronousWithKey:(NSString *)key
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info removeObjectForKey:key];
    [info synchronize];
}
+ (id)getAsynchronousWithKey:(NSString *)key
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    return [info valueForKey:key];
}

@end
