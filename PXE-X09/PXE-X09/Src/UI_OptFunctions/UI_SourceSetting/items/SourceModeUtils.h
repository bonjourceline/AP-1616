//
//  SourceModeUtils.h
//  PXE-X09
//
//  Created by celine on 2018/10/16.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SourceModeUtils : NSObject
+ (instancetype)shareManager;
+ (NSString *)getOutModeName:(int)index;
+ (NSString *)getAuxModeName:(int)index;
+(void)syncSourceTemp;
+(void)syncSource;
@end

NS_ASSUME_NONNULL_END
