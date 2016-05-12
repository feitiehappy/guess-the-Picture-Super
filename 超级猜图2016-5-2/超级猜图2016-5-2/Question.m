//
//  Question.m
//  超级猜图2016-5-2
//
//  Created by 十大大 on 16/5/2.
//  Copyright © 2016年 Y. All rights reserved.
//

#import "Question.h"

@implementation Question

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self=[super init]) {
        self.answer=dict[@"answer"];
        self.title=dict[@"title"];
        self.icon=dict[@"icon"];
        self.optional=dict[@"optional"];
    }
    return self;
}
+(instancetype)QuestionWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
