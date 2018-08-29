//
//  Tools.h
//  chelizi
//
//  Created by cowork on 16/5/13.
//  Copyright © 2016年 chelizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tools : NSObject

+(UILabel *)titleLabel:(NSString *)msg color:(UIColor *)color;
+(UILabel *)titleLabel:(NSString *)msg fontsize:(int)fontsize color:(UIColor *)color;
+(UILabel *)createLabel:(UIView *)addView fontsize:(int)fontsize color:(UIColor *)color;
+ (UIColor *)getColorFromHexCode:(NSString *)hex;
+ (UIImage*)createColorImageWith:(UIColor *)color withSize:(CGSize)size;

/**
 * @返回应用程序物理屏幕大小
 *
 */
CGRect ApplicationBounds();


/**
 * @返回应用程序物理屏幕的高度
 *
 */
CGFloat  ApplicationBoundsHeight();
/**
 * @返回应用程序物理屏幕的高度
 *
 */
CGFloat ApplicationBoundsWidth();

+(id)jsonToObject:(NSString *)msg;

+(NSString *)objectToJson:(id)object;
/**
 * @格式化时间单位
 *
 */
+(NSString *)dateFormatterWithTime:(NSNumber*)time withFormat:(NSString *)format;

//获取uilabel高度
+ (CGRect)getBoundingWithString:(NSString*)string WithSize:(CGSize)size WithFontSize:(CGFloat)fontSize;

@end
