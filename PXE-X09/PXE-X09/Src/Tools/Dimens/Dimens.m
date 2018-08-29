//
//  Dimens.m
//  MT-IOS
//
//  Created by chsdsp on 2017/3/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "Dimens.h"
#import "AppDelegate.h"

#define Thr (1)
#define TWO (0.75)
#define ONE (0.6)
@implementation Dimens{
    
}
+ (double)GDimens:(double)dimens{
    //double mDimens = dimens;
    return dimens*KScreenTYPE;
    /*
    if ([phoneModel isEqualToString:@"iPhone 2G"]) return mDimens/3.0f;
    
    if ([phoneModel isEqualToString:@"iPhone 3G"]) return mDimens/3.0f;
    
    if ([phoneModel isEqualToString:@"iPhone 3GS"]) return mDimens/3.0f;
    
    if ([phoneModel isEqualToString:@"iPhone 4"]) return mDimens/3.0f;
    
    if ([phoneModel isEqualToString:@"iPhone 4S"]) return mDimens/3.0f;
    
    if ([phoneModel isEqualToString:@"iPhone 5"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 5c"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 5s"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 5s"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 6 Plus"]) return mDimens;
    
    if ([phoneModel isEqualToString:@"iPhone 6"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 6s"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 6s Plus"]) return mDimens;
    
    if ([phoneModel isEqualToString:@"iPhone SE"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 7"]) return mDimens*TWO;
    
    if ([phoneModel isEqualToString:@"iPhone 7 Plus"]) return mDimens;
    
    if ([phoneModel isEqualToString:@"iPod Touch 1G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPod Touch 2G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPod Touch 3G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPod Touch 4G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPod Touch 5G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad 1G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad 2"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad Mini 1G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad 3"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad 4"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad Air"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad Mini 2G"])   return mDimens*2.0f/3.0f;
    
    if ([phoneModel isEqualToString:@"iPad5,1"])   return mDimens*0.6;
    
    if ([phoneModel isEqualToString:@"iPhone Simulator"])  return mDimens*2.0f/3.0f;
    
    return mDimens;
     */
}

@end
