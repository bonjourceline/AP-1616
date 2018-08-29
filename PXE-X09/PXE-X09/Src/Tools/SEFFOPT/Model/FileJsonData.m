//
//  FileJsonData.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/12.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "FileJsonData.h"

#import "ChsData.h"
#import "ClientData.h"
#import "DataInfoData.h"

@implementation FileJsonData

- (QIZFileJsonModel *)defualtFileJsonModelData;
{
    QIZFileJsonModel *fileJsonModel = [[QIZFileJsonModel alloc] init];
    
    /*
    //本公司信息
    fileJsonModel.chs.company_brand = @"CHS";
    fileJsonModel.chs.company_briefing_en =@"The company was founded in 2013, is a focus on car DSP audio research and development program integrated company.";
    fileJsonModel.chs.company_briefing_zh =@"公司成立于2013年，是一家专注于车载DSP音频研究开发的方案集成型公司。";
    fileJsonModel.chs.company_contacts = @"Mr Qing";
    fileJsonModel.chs.company_name =@"广州市车厘子电子科技有限公司";
    fileJsonModel.chs.company_qq = @"QQ123456";
    fileJsonModel.chs.company_tel = @"020-87282169";
    fileJsonModel.chs.company_web = @"www.chschs.com";
    fileJsonModel.chs.company_weixin = @"CHSAUDIO";
    
    //客户公司信息
    fileJsonModel.chs.company_name = [self GetAgentIDName:kAgentID];
    fileJsonModel.chs.company_tel = @"020-XXXXXXXX";
    fileJsonModel.chs.company_contacts = @"020-XXXXXXXX";
    fileJsonModel.chs.company_web = @"www.XX.com";
    fileJsonModel.chs.company_weixin = @"WEIXIN";
    fileJsonModel.chs.company_qq = @"QQ";
    fileJsonModel.chs.company_briefing_en = [self GetAgentIDName:kAgentID];
    fileJsonModel.chs.company_briefing_zh = [self GetAgentIDName:kAgentID];
    NSString *companyBrandStr = [NSString stringWithFormat:@"%d", kAgentID];
    fileJsonModel.chs.company_brand = companyBrandStr;
    */
    
    DataInfoData *dataInfo = [[DataInfoData alloc] init];
    //数据信息
    fileJsonModel.data_info.data_user_name = dataInfo.data_user_name;
    fileJsonModel.data_info.data_user_tel = dataInfo.data_user_tel;
    fileJsonModel.data_info.data_user_mailbox = dataInfo.data_user_mailbox;
    
    fileJsonModel.data_info.data_user_name = dataInfo.data_user_name;
    fileJsonModel.data_info.data_user_tel = dataInfo.data_user_tel;
    fileJsonModel.data_info.data_user_mailbox = dataInfo.data_user_mailbox;
    
    fileJsonModel.data_info.data_user_info = @"MC";
    
    fileJsonModel.data_info.data_machine_type = dataInfo.data_machine_type; //Cid
    fileJsonModel.data_info.data_car_type = dataInfo.data_car_type;
    fileJsonModel.data_info.data_car_brand = dataInfo.data_car_brand;
    
    fileJsonModel.data_info.data_json_version = @"JsonV0.00";
    
    
    fileJsonModel.data_info.data_mcu_version = dataInfo.data_mcu_version;
    fileJsonModel.data_info.data_android_version = dataInfo.data_android_version;
    fileJsonModel.data_info.data_ios_version = @"IOS-?";
    fileJsonModel.data_info.data_pc_version = @"PC-?";
    
    fileJsonModel.data_info.data_group_num = dataInfo.data_group_num;
    fileJsonModel.data_info.data_group_name = dataInfo.data_group_name;
    fileJsonModel.data_info.data_eff_briefing = dataInfo.data_eff_briefing;
    fileJsonModel.data_info.data_upload_time = dataInfo.data_upload_time;
    
    fileJsonModel.data_info.data_encryption_byte = 0;
    fileJsonModel.data_info.data_encryption_bool = false;
    fileJsonModel.data_info.data_head_data = 0x5E;
    
    fileJsonModel.fileType = @"single";
    
    return fileJsonModel;
}



@end
