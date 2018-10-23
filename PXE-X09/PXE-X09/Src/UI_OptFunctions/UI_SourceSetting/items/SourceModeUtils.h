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
/**
 获取通道类型名称
 */
+ (NSString*)getOutputSpkTypeNameByIndex:(int)index;
+ (NSString *)getOutModeName:(int)index;
+ (NSString *)getAuxModeName:(int)index;
+(void)syncSourceTemp;
+(void)syncSource;
/**
 设置高电平通道类型
 */
+(void)setHiModeTypeSetting;
/**
 获取高电平类型通道个数
 */
+(int)getHiModeTypeChNum:(int)index;
/**
 设置低电平通道类型
 */
+(void)setAUXModeTypeSetting;
/**
 获取低电平类型通道个数
 */
+(int)getAuxModeTypeChNum:(int)index;
/**
 设置输出通道类型
 */
+(void)setOUTModeTypeSetting;
@end

NS_ASSUME_NONNULL_END
