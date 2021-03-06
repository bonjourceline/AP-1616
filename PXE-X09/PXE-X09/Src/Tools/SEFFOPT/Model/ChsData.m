//
//  ChsData.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/12.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "ChsData.h"

@implementation ChsData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.company_brand = @"CHS";
        self.company_briefing_en =@"The company was founded in 2013, is a focus on car DSP audio research and development program integrated company.";
        self.company_briefing_zh =@"公司成立于2013年，是一家专注于车载DSP音频研究开发的方案集成型公司。";
        self.company_contacts = @"Mr Qing";
        self.company_name =@"广州市车厘子电子科技有限公司";
        self.company_qq = @"QQ123456";
        self.company_tel = @"020-87282169";
        self.company_web = @"www.chschs.com";
        self.company_weixin = @"CHSAUDIO";
    }
    return self;
}

@end
