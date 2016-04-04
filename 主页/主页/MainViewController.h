//
//  MainViewController.h
//  iTranslation
//
//  Created by 关 旭 on 14-9-27.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "PopupView.h"


#define kCellHeight 60
#define kBottomViewHeight 60

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,IFlyRecognizerViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end
