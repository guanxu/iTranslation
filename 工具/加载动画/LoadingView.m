//
//  LoadingView.m
//  testWebR
//
//  Created by 学华 刘 on 11-12-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView
static LoadingView *loadingView;

- (id)init
{
	if (!loadingView) {
		loadingView = [super init];
	}
	return loadingView;
}
+ (LoadingView *)sharedLoadingView
{
	if (!loadingView) {
		loadingView = [[LoadingView alloc] init];
	}
	return loadingView;
}

- (void)loadingViewInView:(UIView *)superview statusMessage:(NSString *)statusMessage
{
	if (_HUD) {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:superview];
    [superview addSubview:_HUD];
//    _HUD.mode = MBProgressHUDModeDeterminate;
    _HUD.labelText = statusMessage;
    [_HUD show:YES];
}

-(void)loadingViewInView:(UIView *)aSuperview
{
    return [loadingView loadingViewInView:aSuperview statusMessage:@"请稍后"];
}

- (void)removeView
{
    if (_HUD) {
        [_HUD hide:YES];
        [_HUD removeFromSuperViewOnHide];
    }else{
        GLog(@"no waiting view");
    }
}
@end
