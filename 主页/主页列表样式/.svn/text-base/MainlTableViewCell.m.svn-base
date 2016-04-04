//
//  MainlTableViewCell.m
//  iTranslation
//
//  Created by 关 旭 on 14-9-27.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import "MainlTableViewCell.h"
#import "MakeInterface.h"
#import "MainViewController.h"

@implementation MainlTableViewCell
{
    UILabel *inputLabel,*translateLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //用户输入的文字
        inputLabel = [MakeInterface createCommonLabelWithFrame:CGRectMake(10, 10, 300, 20)];
        inputLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:inputLabel];
        //翻译后的文字
        translateLabel = [MakeInterface createCommonLabelWithFrame:CGRectMake(10, kCellHeight-30, 300, 20)];
        translateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:translateLabel];
        //线
        [self addSubview:[MakeInterface drawLineWithFrame:CGRectMake(0, 59, 320, 1)]];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 布局
- (void)layoutWithResult:(TranslateResult *)result
{
    inputLabel.text = result.src;
    translateLabel.text = result.dst;
}


@end
