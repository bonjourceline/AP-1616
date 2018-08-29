//
//  SystemModel.h
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 tgaudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemModel : NSObject

@property (nonatomic, strong) NSArray *cur_password_data; //8个字节
@property (nonatomic, strong) NSArray *eff_group_name; //16个字节
@property (nonatomic, strong) NSArray *out_led;   //16个字节
@property (nonatomic, strong) NSArray *pc_source_set;  //8个字节
@property (nonatomic, strong) NSArray *sound_delay_field; //50个字节
@property (nonatomic, strong) NSArray *system_data;  //8个字节
@property (nonatomic, strong) NSArray *system_group_name; //16个字节
@property (nonatomic, strong) NSArray *system_spk_type; //16个字节

@end
