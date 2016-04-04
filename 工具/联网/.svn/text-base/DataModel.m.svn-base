//
//  RTVDataModel.m
//  EWalking
//
//  Created by Ma Jianglin on 7/11/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "DataModel.h"

@implementation NSDictionary (NullReplace)

- (id)objectForKeyNotNull:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]] ||
        [object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSArray class]] ||
        [object isKindOfClass:[NSDictionary class]])
    {
        return object;
    }
    return nil;
}

@end

@implementation TranslateResult

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.src = [dict objectForKeyNotNull:@"src"];
        self.dst = [dict objectForKeyNotNull:@"dst"];
        
    }
    return self;
}

+ (TranslateResult *)newsItemWithDict:(NSDictionary *)dict
{
    return [[TranslateResult alloc] initWithDict:dict];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.src = [aDecoder decodeObjectForKey:@"src"];
        self.dst = [aDecoder decodeObjectForKey:@"dst"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.src forKey:@"src"];
    [aCoder encodeObject:self.dst forKey:@"dst"];
    
}

@end
