//
//  Client.m
//  PXE-0850P
//
//  Created by tiger on 2017/2/27.
//  Copyright © 2017年 hmaudio. All rights reserved.
//

#import "ClientModel.h"
#import "MacDefine.h"

@implementation ClientModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.company_name = [self GetAgentIDName:AgentID];
        self.company_tel = @"020-XXXXXXXX";
        self.company_contacts = @"020-XXXXXXXX";
        self.company_web = @"www.XX.com";
        self.company_weixin = @"WEIXIN";
        self.company_qq = @"QQ";
        self.company_briefing_en = [self GetAgentIDName:AgentID];
        self.company_briefing_zh = [self GetAgentIDName:AgentID];
        NSString *companyBrandStr = [NSString stringWithFormat:@"%d", AgentID];
        self.company_brand = companyBrandStr;
    }
    return self;
}

/**
 * 获取客户名称
 */
-(NSString *)GetAgentIDName:(int)agentID{
    NSString *name = @"CHS";
    switch (agentID) {
        case 1: name=@"佰芙";break;
        case 2: name=@"交叉火力";break;
        case 3: name=@"合德";break;
        case 4: name=@"惠州惠诺";break;
        case 5: name=@"御音";break;
        case 6: name=@"锐高";break;
        case 7: name=@"迪声";break;
        case 8: name=@"声鑫";break;
        case 9: name=@"鹏辉";break;
        case 10: name=@"芬朗";break;
        case 11: name=@"汇隆";break;
        case 12: name=@"卡莱";break;
        case 13: name=@"云晶";break;
        case 14: name=@"江波";break;
        case 15: name=@"俊宏";break;
        case 16: name=@"酷派";break;
        case 17: name=@"盈必达";break;
        case 18: name=@"车厘子";break;
        case 19: name=@"荣鼎";break;
        case 20: name=@"译宝";break;
        default: break;
    }
    return name;
}


@end
