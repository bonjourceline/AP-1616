//
//  DataInfoModel.h
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 tgaudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataInfoModel : NSObject

@property (nonatomic, copy) NSString *data_android_version;
@property (nonatomic, copy) NSString *data_car_brand;
@property (nonatomic, copy) NSString *data_car_type;
@property (nonatomic, copy) NSString *data_eff_briefing;

@property (nonatomic, copy) NSString *data_user_tel;
@property (nonatomic, copy) NSString *data_user_name;
@property (nonatomic, copy) NSString *data_group_name;
@property (nonatomic, copy) NSString *data_group_num;
@property (nonatomic, copy) NSString *data_user_mailbox;
@property (nonatomic, copy) NSString *data_ios_version;
@property (nonatomic, copy) NSString *data_json_version;
@property (nonatomic, copy) NSString *data_machine_type;
@property (nonatomic, copy) NSString *data_mcu_version;
@property (nonatomic, copy) NSString *data_pc_version;

@property (nonatomic, copy) NSString *data_upload_time;
@property (nonatomic, copy) NSString *data_user_info;


@property (nonatomic, assign) int data_head_data;
@property (nonatomic, assign) int data_encryption_byte;
@property (nonatomic, assign) bool data_encryption_bool;

@end
