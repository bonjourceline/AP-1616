//
//  Tools.m
//  chelizi
//
//  Created by cowork on 16/5/13.
//  Copyright © 2016年 chelizi. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+(UILabel *)titleLabel:(NSString *)msg color:(UIColor *)color{
    return [Tools titleLabel:msg fontsize:20 color:color];
}

+(UILabel *)titleLabel:(NSString *)msg fontsize:(int)fontsize color:(UIColor *)color{
    
    UILabel *titleview = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleview.backgroundColor = [UIColor clearColor];
    titleview.textAlignment = NSTextAlignmentCenter;
    titleview.font = [UIFont boldSystemFontOfSize:fontsize];
    titleview.text = msg;
    titleview.textColor = color;
    
    return titleview;
}


+(UILabel *)createLabel:(UIView *)addView fontsize:(int)fontsize color:(UIColor *)color{
    
    UILabel *titleview = [[UILabel alloc]initWithFrame:CGRectZero];
    titleview.translatesAutoresizingMaskIntoConstraints = NO;
    titleview.backgroundColor = [UIColor clearColor];
    titleview.font = [UIFont systemFontOfSize:fontsize];
    titleview.text = @"";
    titleview.textColor = color;
    [addView addSubview:titleview];
    return titleview;
}

+ (UIColor *)getColorFromHexCode:(NSString *)hex {
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (UIImage*)createColorImageWith:(UIColor *)color withSize:(CGSize)size
{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}


CGRect ApplicationBounds()
{
    return [UIScreen mainScreen].bounds;
}

CGFloat ApplicationBoundsHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}
CGFloat ApplicationBoundsWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}


+(id)jsonToObject:(NSString *)msg{
    return [NSJSONSerialization JSONObjectWithData: [msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

+(NSString *)objectToJson:(id)object{
    return [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}


+(NSString *)dateFormatterWithTime:(NSNumber*)time withFormat:(NSString *)format
{
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//获取uilabel 的高度
+ (CGRect)getBoundingWithString:(NSString*)string WithSize:(CGSize)size WithFontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

@end
