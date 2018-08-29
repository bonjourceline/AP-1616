//
//  QIZFileJsonModel.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/11/29.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "BaseModel.h"
@class CompanyInfo,CustomerInfo,DataInfo,FileDataStruct,DataMusic,DataOutput,DataSystem;
//,Music,Output,System;

@interface QIZFileJsonModel : BaseModel

@property (nonatomic,strong) CompanyInfo *chs;
@property (nonatomic,strong) CustomerInfo *client;
@property (nonatomic,strong) FileDataStruct *data;
@property (nonatomic,strong) DataInfo *data_info;
@property (nonatomic,copy) NSString *fileType;

@end

@interface CompanyInfo : BaseModel

@property (nonatomic,copy) NSString *company_brand;
@property (nonatomic,copy) NSString *company_briefing_en;
@property (nonatomic,copy) NSString *company_briefing_zh;
@property (nonatomic,copy) NSString *company_contacts;
@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,copy) NSString *company_qq;
@property (nonatomic,copy) NSString *company_tel;
@property (nonatomic,copy) NSString *company_web;
@property (nonatomic,copy) NSString *company_weixin;

@end

@interface CustomerInfo : BaseModel

@property (nonatomic,copy) NSString *company_brand;
@property (nonatomic,copy) NSString *company_briefing_en;
@property (nonatomic,copy) NSString *company_briefing_zh;
@property (nonatomic,copy) NSString *company_contacts;
@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,copy) NSString *company_qq;
@property (nonatomic,copy) NSString *company_tel;
@property (nonatomic,copy) NSString *company_web;
@property (nonatomic,copy) NSString *company_weixin;

@end

@interface DataInfo : BaseModel

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

@interface FileDataStruct : BaseModel

/** 组名称 */
@property (nonatomic, strong) NSArray *group_name;
@property (nonatomic, strong) DataMusic* music;
@property (nonatomic, strong) DataOutput* output;
@property (nonatomic, strong) DataSystem* system;

@end

@interface DataMusic : BaseModel

@property (nonatomic, strong) NSArray *music;

@end

@interface DataOutput : BaseModel

@property (nonatomic, strong) NSArray *output;

@end

@interface DataSystem : BaseModel

@property (nonatomic, strong) NSArray *cur_password_data; //8个字节
@property (nonatomic, strong) NSArray *eff_group_name; //16个字节
@property (nonatomic, strong) NSArray *out_led;   //16个字节
@property (nonatomic, strong) NSArray *pc_source_set;  //8个字节
@property (nonatomic, strong) NSArray *sound_delay_field; //50个字节
@property (nonatomic, strong) NSArray *system_data;  //8个字节
@property (nonatomic, strong) NSArray *system_group_name; //16个字节
@property (nonatomic, strong) NSArray *system_spk_type; //16个字节

@end





