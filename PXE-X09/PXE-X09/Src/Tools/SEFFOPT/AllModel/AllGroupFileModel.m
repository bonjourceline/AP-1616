//
//  AllGroupFileModel.m
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 hmaudio. All rights reserved.
//

#import "AllGroupFileModel.h"
#import "MJExtension.h"
#import "DataModel.h"

@implementation AllGroupFileModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chs = [[ChsModel alloc] init];
        self.client = [[ClientModel alloc] init];
        self.data_info = [[DataInfoModel alloc] init];
        self.system = [[SystemModel alloc] init];
    }
    return self;

}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data" : [DataModel class]};
}


@end
