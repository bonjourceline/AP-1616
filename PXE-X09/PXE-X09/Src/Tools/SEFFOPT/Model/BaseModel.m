//
//  BaseModel.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/9.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseModel.h"



@implementation BaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
