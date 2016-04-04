//
//  LoadingView.h
//  testWebR
//
//  Created by 学华 刘 on 11-12-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoadingView : NSObject

@property (strong) MBProgressHUD *HUD;

+ (LoadingView *)sharedLoadingView;

- (void)loadingViewInView:(UIView *)aSuperview;
- (void)loadingViewInView:(UIView *)aSuperview statusMessage:(NSString *)statusMessage;
- (void)removeView;
@end
