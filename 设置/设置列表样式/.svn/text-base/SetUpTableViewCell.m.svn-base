//
//  SetUpTableViewCell.m
//  iTranslation
//
//  Created by 关旭 on 14-10-10.
//  Copyright (c) 2014年 guanxu. All rights reserved.
//

#import "SetUpTableViewCell.h"
#import "MakeInterface.h"

@implementation SetUpTableViewCell
{
    UIImageView *cellIcon;
    UILabel *cellLabel;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //线
        [self addSubview:[MakeInterface drawLineWithFrame:CGRectMake(0, 0, 320, 1)]];
        //图标
        cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 21, 21)];
        [self addSubview:cellIcon];
        //文字
        cellLabel = [MakeInterface createCommonLabelWithFrame:CGRectMake(80, 16, 100, 20)];
        cellLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:cellLabel];
        //箭头
        UIImageView *cellArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 20, 6, 17)];
        cellArrow.image = [UIImage imageNamed:@"cell_arrow"];
        [self addSubview:cellArrow];
        //线
        [self addSubview:[MakeInterface drawLineWithFrame:CGRectMake(0, 50, 320, 1)]];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 布局
- (void)layoutWithCellIconName:(NSString *)cellIconName CellStr:(NSString *)cellStr
{
    cellIcon.image = [UIImage imageNamed:cellIconName];
    cellLabel.text = cellStr;
}

@end
