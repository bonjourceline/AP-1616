//
//  QIZFileJsonModel.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/11/29.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "QIZFileJsonModel.h"

//+ (NSDictionary *)objectClassInArray{
//    return @{@"brands" : [Brands_List class],
//             @"cartpyes" : [Cartpyes_List class],
//             @"macs" : [Macs_List class],
//             @"macsAgentName" : [MacsAgentName_List class]};
//}

@implementation QIZFileJsonModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chs = [[CompanyInfo alloc] init];
        self.client = [[CustomerInfo alloc] init];
        self.data = [[FileDataStruct alloc] init];
        
        self.data.group_name = [[NSArray alloc] init];
        self.data.music = [[DataMusic alloc] init];
        self.data.output = [[DataOutput alloc] init];
        self.data.system = [[DataSystem alloc] init];
        
        self.data_info = [[DataInfo alloc] init];
        self.fileType = @"";
    }
    return self;
}

@end

@implementation CompanyInfo

@end

@implementation CustomerInfo

@end

@implementation DataInfo

@end

@implementation FileDataStruct

@end

@implementation DataMusic

@end

@implementation DataOutput

@end

@implementation DataSystem

@end


