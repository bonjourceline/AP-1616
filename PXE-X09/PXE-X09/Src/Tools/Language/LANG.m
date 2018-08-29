//
//  LANG.m
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "LANG.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@implementation LANG{
    
}
//zh-Hans-CN :簡體中文

//zh-Hant-CN :繁体中文
//zh-Hant-HK :香港
//zh-Hant-TW
//zh-Hant-MO

//en-US      :English(United States)


+ (NSString *)DPLocalizedString:(NSString *)translation_key {
    
    NSString * s = NSLocalizedString(translation_key, nil);
    
    NSString *language = CURR_LANG;
    //NSLog(@"language.length=%ld",language.length);
    
    if(language.length >= 7){
        language = [language substringToIndex:7];
    }
    if ([language isEqual:@"zh-Hant"]) {//繁体
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if ([language isEqual:@"zh-Hans"]) {//简体
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else{//英文
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en-US" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }

    return s;
}
+(BOOL)isChinese{
    NSString *language = CURR_LANG;
    if ([language hasPrefix:@"zh-Hans"]) {
        return true;
    }else{
        
        return false;
        
        }
    
}

@end
