//
//  PAIPAModel.m
//  PreviewWebDemo
//
//  Created by Michael Tang on 2019/1/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "PAIPAModel.h"
#import <YYModel/YYModel.h>

@implementation PAAdsModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    [self yy_modelInitWithCoder:aDecoder];
    return self;
}
@end

@implementation PAIPAModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{ @"ads" : [PAAdsModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    [self yy_modelInitWithCoder:aDecoder];
    return self;
}

@end
