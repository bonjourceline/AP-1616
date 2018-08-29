//
//  DataModel.h
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 tgaudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicGroupModel.h"
#import "OutputGroupModel.h"

@interface DataModel : NSObject

/** 组名称 */
@property (nonatomic, strong) NSArray *group_name;

@property (nonatomic, strong) MusicGroupModel *music;
@property (nonatomic, strong) OutputGroupModel *output;

@end
