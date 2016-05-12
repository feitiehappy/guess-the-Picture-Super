//
//  Question.h
//  超级猜图2016-5-2
//
//  Created by 十大大 on 16/5/2.
//  Copyright © 2016年 Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property(nonatomic,copy)NSString* answer;
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,strong)NSArray* optional;
-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)QuestionWithDict:(NSDictionary*)dict;
@end
