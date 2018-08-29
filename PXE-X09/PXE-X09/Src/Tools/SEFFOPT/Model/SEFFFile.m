//
//  SEFFFile.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/8.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "SEFFFile.h"

@implementation SEFFFile

- (instancetype)init
{
    self = [super init];
    if (self) {
        _autoID = 0; //数据库用
        _file_id = @"file_id";
        _file_type = @"single";
        _file_name = @"hell world!";
        _file_path = @"0"; //沙盒路径
        _file_favorite = @"0";
        _file_love = @"0";
        _file_size = @"200";
        _file_time = @"0"; //系统时间
        _file_msg = @"file_msg";
        
        _data_user_name = @"";
        _data_machine_type = @"PXE-0850P";
        _data_car_type = @"";
        _data_car_brand = @"";
        _data_group_name = @"";
        _data_upload_time = @"";
        _data_eff_briefing = @"";
        
        _list_sel = @"0";
        _list_is_open = @"0";
    }
    return self;
}


@end
