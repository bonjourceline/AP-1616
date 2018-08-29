//
//  SaveLoginInfo.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/12.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SaveLoginInfo : BaseModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *car_name;
@property (nonatomic, copy) NSString *mac_name;
@property (nonatomic, copy) NSString *sign;


@end
