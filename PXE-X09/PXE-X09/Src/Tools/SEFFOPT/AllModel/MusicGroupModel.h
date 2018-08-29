//
//  MusicGroupModel.h
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 tgaudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicGroupModel : NSObject

//如果已经解析到数组，直接用数组（一维，二维都用数组）
@property (nonatomic, strong) NSArray *music;

@end
