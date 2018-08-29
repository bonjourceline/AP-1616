//
//  LANG.h
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])

@interface LANG : NSObject {
    
}

+ (NSString *)DPLocalizedString:(NSString *)translation_key;
+(BOOL)isChinese;
@end
