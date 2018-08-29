//
//  LANG.m
//  MT-IOS
//
//  Created by chsdsp on 2017/3/1.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import "PIMG.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacDefine.h"


@implementation PIMG{
    
}

+ (NSString *)DPIMG:(NSString *)img {
//    if(DEFALIB == DEF_LIB){
//        return [NSString stringWithFormat:@"YJ_Framework_Bundle.bundle/Contents/Resources/%@",img];
//    }else{
        return [NSString stringWithFormat:@"%@",img];
//    }
    
}

@end
