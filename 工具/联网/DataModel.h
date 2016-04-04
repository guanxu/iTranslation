//
//  DataModel.h
//  EWalking
//
//  Created by Ma Jianglin on 7/11/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>


//百度翻译
@interface TranslateResult : NSObject

@property (nonatomic, strong) NSString *src;   //输入
@property (nonatomic, strong) NSString *dst;   //输出

+ (TranslateResult *)newsItemWithDict:(NSDictionary *)dict;

@end

