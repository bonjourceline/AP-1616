//
//  DataModel.m
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 tgaudio. All rights reserved.
//

#import "DataModel.h"
#import "MJExtension.h"

@implementation DataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.group_name = @[];
        self.music = [[MusicGroupModel alloc] init];
        self.output = [[OutputGroupModel alloc] init];
    }
    return self;
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"music" : [MusicGroupModel class], @"output" : [OutputGroupModel class]};
}

@end
