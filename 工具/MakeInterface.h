//
//  MakeInterface.h
//  iTranslation
//
//  Created by 关 旭 on 14-9-27.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakeInterface : NSObject

#pragma mark - 创建UILabel
+ (UILabel *)createCommonLabelWithFrame:(CGRect)frame;

#pragma mark - 创建UIButton
+ (UIButton *)createCommonButtonWithFrame:(CGRect)frame
                                      tag:(int)tag
                                   target:(id)target
                                 selector:(SEL)selector;

#pragma mark - 隐藏键盘按钮
+ (UIButton *) hideKeyboardBtnWithTarget:(id)target Selector:(SEL)selector;

#pragma mark 画线
+(UIImageView *)drawLineWithFrame:(CGRect)frame;

#pragma mark - 导航栏右侧按钮
+(UIButton *)createRightBtnWithImageName:(NSString *)imageName
                                  Target:(id)target
                                selector:(SEL)selector;

#pragma mark 比较app得版本号跟当前版本号高低
+ (BOOL)checkVresionWithAppStoreVersion:(NSString *)appStoreVresion CurrentVresion:(NSString *)currentVresion;

#pragma mark - 持久化保存
+ (void)setAsynchronous:(id)object WithKey:(NSString *)key;
+ (void)clearAsynchronousWithKey:(NSString *)key;
+ (id)getAsynchronousWithKey:(NSString *)key;

@end
