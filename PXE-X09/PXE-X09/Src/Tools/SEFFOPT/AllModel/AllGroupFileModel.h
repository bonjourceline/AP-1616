//
//  AllGroupFileModel.h
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 hmaudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChsModel.h"
#import "ClientModel.h"
#import "DataModel.h"
#import "DataInfoModel.h"
#import "SystemModel.h"

@interface AllGroupFileModel : NSObject

/** 本公司信息 */
@property (nonatomic, strong) ChsModel *chs;
/** 客户信息 */
@property (nonatomic, strong) ClientModel *client;

/** 整机数据(存放数据模型) */
@property (nonatomic, strong) NSArray *data;

/** 数据信息 */
@property (nonatomic, strong) DataInfoModel *data_info;
/** 文件类型 */
@property (nonatomic, copy) NSString *fileType;

/** 系统数据信息 */
@property (nonatomic, strong) SystemModel *system;

@end
