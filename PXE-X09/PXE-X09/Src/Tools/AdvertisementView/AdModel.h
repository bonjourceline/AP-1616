//
//  AdModel.h
//  DSP-Play
//
//  Created by chs on 2017/12/22.
//  Copyright © 2017年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject
@property (nonatomic,assign)int Ad_Status;
@property (nonatomic,assign)NSInteger AgentID;
@property (nonatomic,copy)NSString *SoftVersion;
@property (nonatomic,assign)NSInteger Upgrade_Status;
@property (nonatomic,copy)NSString *ctime;
@property (nonatomic,copy)NSString *ip;
@property (nonatomic,copy)NSString *macName;
@property (nonatomic,assign)NSInteger softtype;
@property (nonatomic,copy)NSString *Ad_Title;//标题
@property (nonatomic,copy)NSString *Ad_Image_Path;//图片地址
@property (nonatomic,copy)NSString *Ad_URL;//图片链接
@property (nonatomic,copy)NSString *Ad_Close_URL;//关闭广告链接
@property (nonatomic,assign)NSInteger AdID;

@end
