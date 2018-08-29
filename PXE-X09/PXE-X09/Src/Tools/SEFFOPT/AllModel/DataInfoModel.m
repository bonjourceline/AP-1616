//
//  DataInfoModel.m
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 tgaudio. All rights reserved.
//

#import "DataInfoModel.h"

@implementation DataInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //        self.data_user_name = dataInfo.data_user_name;
        //        self.data_user_tel = dataInfo.data_user_tel;
        //        self.data_user_mailbox = dataInfo.data_user_mailbox;
        //
        //        self.data_user_name = dataInfo.data_user_name;
        //        self.data_user_tel = dataInfo.data_user_tel;
        //        self.data_user_mailbox = dataInfo.data_user_mailbox;
        
        self.data_user_info = @"MC";
        
        //        self.data_machine_type = dataInfo.data_machine_type; //Cid
        //        self.data_car_type = dataInfo.data_car_type;
        //        self.data_car_brand = dataInfo.data_car_brand;
        
        self.data_json_version = @"JsonV0.00";
        
        
        //        self.data_mcu_version = dataInfo.data_mcu_version;
        //        self.data_android_version = dataInfo.data_android_version;
        self.data_ios_version = @"IOS-?";
        self.data_pc_version = @"PC-?";
        
        //        self.data_group_num = dataInfo.data_group_num;
        //        self.data_group_name = dataInfo.data_group_name;
        //        self.data_eff_briefing = dataInfo.data_eff_briefing;
        //        self.data_upload_time = dataInfo.data_upload_time;
        
        self.data_encryption_byte = 0;
        self.data_encryption_bool = false;
        self.data_head_data = 0x5E;
        
    }
    return self;
}


@end
