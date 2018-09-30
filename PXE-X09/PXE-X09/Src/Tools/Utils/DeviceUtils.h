//
//  DeviceUtils.h
//  XG-DCP812-R12
//
//  Created by chs on 2017/12/13.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtils : NSObject
/*
 * 系统版本号
 */
+ (NSString *) currentVersion ;
/*
 * 设备型号
 */
+ (NSString *) deviceModel ;

+ (NSString *)identifier;
+ (BOOL)isFisrtStarApp;
+(void)setFirstStart;
@end
