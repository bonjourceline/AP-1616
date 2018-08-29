//
//  SEFFFile.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/8.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEFFFile : NSObject

@property (nonatomic, assign) int autoID; //数据库用
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *file_type;
@property (nonatomic, copy) NSString *file_name;
@property (nonatomic, copy) NSString *file_path;
@property (nonatomic, copy) NSString *file_favorite;
@property (nonatomic, copy) NSString *file_love;
@property (nonatomic, copy) NSString *file_size;
@property (nonatomic, copy) NSString *file_time;
@property (nonatomic, copy) NSString *file_msg;

@property (nonatomic, copy) NSString *data_user_name;
@property (nonatomic, copy) NSString *data_machine_type;
@property (nonatomic, copy) NSString *data_car_type;
@property (nonatomic, copy) NSString *data_car_brand;
@property (nonatomic, copy) NSString *data_group_name;
@property (nonatomic, copy) NSString *data_upload_time;
@property (nonatomic, copy) NSString *data_eff_briefing;

@property (nonatomic, copy) NSString *list_sel;
@property (nonatomic, copy) NSString *list_is_open;

@property (nonatomic, copy) NSString *apply_time;


@end
