//
//  SourceModeUtils.m
//  PXE-X09
//
//  Created by celine on 2018/10/16.
//  Copyright © 2018 dsp. All rights reserved.
//

#import "SourceModeUtils.h"

@implementation SourceModeUtils

+ (NSString *) getOutModeName:(int)index{
    NSString *str=@"";
    NSArray *nameArray=@[
                         [LANG DPLocalizedString:@"自定义"],
                         [LANG DPLocalizedString:@"前声场立体声"],
                         [LANG DPLocalizedString:@"四声道全频"],
                         [LANG DPLocalizedString:@"四声道全频+超低"],
                         [LANG DPLocalizedString:@"四声道全频+左右超低"],
                         
                         [LANG DPLocalizedString:@"前主动二分频+后全频"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+超低"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+左右超低"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+中置+左右超低"],
                         [LANG DPLocalizedString:@"前主动二分频+后全频+中置+超低"],
                         
                         [LANG DPLocalizedString:@"前主动三分频+后二分频+中置+超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后二分频+中置+左右超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后全频+中置+超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后全频+中置+左右超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后全频+超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后全频+左右超低"],
                         [LANG DPLocalizedString:@"前主动三分频+后主动三分频+中置高/低+左右超低"],
                         
                         ];
    if (nameArray.count>index) {
        str=[nameArray objectAtIndex:index];
    }
    return str;
}
+(NSString *)getAuxModeName:(int)index{
    NSString *str=@"";
    NSArray *nameArray=@[
                         [LANG DPLocalizedString:@"自定义"],
                         [LANG DPLocalizedString:@"立体声"],
                         [LANG DPLocalizedString:@"四声道"],
                         [LANG DPLocalizedString:@"六声道（5.1）"],
                         [LANG DPLocalizedString:@"八声道（7.1）"],
                         ];
    if (nameArray.count>index) {
        str=[nameArray objectAtIndex:index];
    }
    return str;
}
@end
