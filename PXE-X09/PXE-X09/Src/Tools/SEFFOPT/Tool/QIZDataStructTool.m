//
//  QIZDataStructTool.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/26.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "QIZDataStructTool.h"
#import "QIZFileJsonModel.h"
#import "MJExtension.h"
#import "AllGroupFileModel.h"
#import "DataModel.h"
#import "MusicGroupModel.h"
#import "OutputGroupModel.h"


@implementation QIZDataStructTool

-(NSString *)GetAgentIDName:(int)agentID{
    NSString *name = @"CHS";
    switch (agentID) {
        case 1: name=@"佰芙";break;
        case 2: name=@"阿尔派";break;
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

-(NSString *)GetAgentIDNameEN:(int)agentID{
    NSString *name = @"CHS";
    switch (agentID) {
        case 1: name=@"BF";break;
        case 2: name=@"AP";break;
        case 3: name=@"HD";break;
        case 4: name=@"HZHY";break;
        case 5: name=@"YY";break;
        case 6: name=@"RG";break;
        case 7: name=@"DS";break;
        case 8: name=@"SX";break;
        case 9: name=@"PH";break;
        case 10: name=@"FL";break;
        case 11: name=@"HL";break;
        case 12: name=@"KL";break;
        case 13: name=@"YJ";break;
        case 14: name=@"JB";break;
        case 15: name=@"JH";break;
        case 16: name=@"KP";break;
        case 17: name=@"YBD";break;
        case 18: name=@"CHS";break;
        case 19: name=@"RD";break;
        case 20: name=@"YB";break;
        default: break;
    }
    return name;
}
-(NSDictionary *)createJsonFileDictionary{
    
    QIZFileJsonModel *fileModel = [[QIZFileJsonModel alloc] init];
    
    //本公司信息
    fileModel.chs.company_brand = @"CHS";
    fileModel.chs.company_briefing_en = @"The company was founded in 2013, is a focus on car DSP audio research and development program integrated company.";
    fileModel.chs.company_briefing_zh = @"公司成立于2013年，是一家专注于车载DSP音频研究开发的方案集成型公司。";
    fileModel.chs.company_contacts = @"Mr Qing";
    fileModel.chs.company_name = @"广州市车厘子电子科技有限公司";
    fileModel.chs.company_qq = @"";
    fileModel.chs.company_tel = @"020-87282169";
    fileModel.chs.company_web = @"www.chschs.com";
    fileModel.chs.company_weixin = @"CHSAUDIO";
    
    //客户公司信息
    fileModel.client.company_brand = [NSString stringWithFormat:@"%d",AgentID]; //文件读取判断必须
    fileModel.client.company_briefing_en = [self GetAgentIDNameEN:AgentID];
    fileModel.client.company_briefing_zh=[self GetAgentIDName:AgentID];
    fileModel.client.company_contacts=@"";
    fileModel.client.company_name=[self GetAgentIDName:AgentID];
    fileModel.client.company_qq=@"";
    fileModel.client.company_tel=@"";
    fileModel.client.company_web=@"";
    fileModel.client.company_weixin=@"";
    
    //数据信息
    fileModel.data_info.data_android_version = @"ANYJ-AV1.01";
    fileModel.data_info.data_car_brand = @"";
    fileModel.data_info.data_car_type = @"";
    fileModel.data_info.data_eff_briefing = SEFFFile_name;
    fileModel.data_info.data_user_tel = @"";
    fileModel.data_info.data_user_name = @"";
    fileModel.data_info.data_group_name = @"";
    fileModel.data_info.data_group_num = @"0";
    fileModel.data_info.data_user_mailbox = @"";
    fileModel.data_info.data_ios_version = App_versions;
    fileModel.data_info.data_json_version = Json_versions;
    fileModel.data_info.data_machine_type = MAC_Type; //文件读取判断必须
    fileModel.data_info.data_mcu_version = @"";
    fileModel.data_info.data_pc_version = @"PC-?";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    fileModel.data_info.data_upload_time = strDate;
    fileModel.data_info.data_user_info = @"MT";
    fileModel.data_info.data_head_data = HEAD_DATA;
    fileModel.data_info.data_encryption_byte = 0;
    fileModel.data_info.data_encryption_bool = false;
    
    fileModel.fileType = @"single";
    
    NSMutableArray *arrayMusic = [NSMutableArray array];
    
    for(int i=0;i<IN_CH_MAX;i++){
        NSMutableArray *arrayMusicTemp= [NSMutableArray array];
        if(BOOL_USE_INS){
            FillSedData_INS_StructCHBuf(i);
            for(int j=0;j<INS_S_LEN;j++){
                [arrayMusicTemp addObject:[NSNumber numberWithUnsignedInteger:ChannelBuf[j]]];
            }
        }else{
            FillSedDataStructCHBuf(MUSIC, i);
            for(int j=0;j<IN_LEN;j++){
                [arrayMusicTemp addObject:[NSNumber numberWithUnsignedInteger:ChannelBuf[j]]];
            }
        }
        
        [arrayMusic addObject:arrayMusicTemp];
    }
    
    fileModel.data.music.music = arrayMusic;
    
    NSMutableArray *arrayOutput = [NSMutableArray array];
    for(int i=0;i<Output_CH_MAX;i++){
        FillSedDataStructCHBuf(OUTPUT, i);
        NSMutableArray *arrayOutputTemp = [NSMutableArray array];
        for(int j=0;j<OUT_LEN;j++){
            [arrayOutputTemp addObject:[NSNumber numberWithUnsignedInteger:ChannelBuf[j]]];
        }
        [arrayOutput addObject:arrayOutputTemp];
    }
    fileModel.data.output.output = arrayOutput;

    //系统数据
    uint8 SystemBuf[16];
    //cur_password_data
    NSMutableArray *cur_password_data = [NSMutableArray array]; //8
    for (int i=0; i<8; i++) {
        [cur_password_data addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    fileModel.data.system.cur_password_data = cur_password_data;
    
    //eff_group_name
    NSMutableArray *eff_group_name = [NSMutableArray array]; //8
    for (int i=0; i<16; i++) {
        [eff_group_name addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    fileModel.data.system.eff_group_name = eff_group_name;
    
    //out_led
    NSMutableArray *out_led = [NSMutableArray array];
    for (int i=0; i<16; i++) {
        [out_led addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    fileModel.data.system.out_led = out_led;
    
    //sound_delay_field
    NSMutableArray *sound_delay_field = [NSMutableArray array];//50
    for (int i=0; i<50; i++) {
        [sound_delay_field addObject:[NSNumber numberWithUnsignedInteger:RecStructData.SoundFieldSystem.SoundDelayField[i]]];
    }
    fileModel.data.system.sound_delay_field = sound_delay_field;

    
    //PC_SOURCE_SET
    NSMutableArray *arraySystemTemp = [NSMutableArray array];
    SystemBuf[0] = RecStructData.System.input_source;
    SystemBuf[1] = RecStructData.System.mixer_source;
    SystemBuf[2] = RecStructData.System.InSwitch[0];
    SystemBuf[3] = RecStructData.System.InSwitch[1];
    SystemBuf[4] = RecStructData.System.InSwitch[2];
    SystemBuf[5] = RecStructData.System.InSwitch[3];
    SystemBuf[6] = RecStructData.System.InSwitch[4];
    SystemBuf[7] = RecStructData.System.none1;
    for (int i=0; i<8; i++) {
        [arraySystemTemp addObject:[NSNumber numberWithUnsignedInteger:SystemBuf[i]]];
    }
    fileModel.data.system.pc_source_set = arraySystemTemp;
    
    //system_data
    NSMutableArray *system_data = [NSMutableArray array];//8
    SystemBuf[0] = RecStructData.System.main_vol;
    SystemBuf[1] = (RecStructData.System.main_vol >> 8) & 0xff;
    SystemBuf[2] = RecStructData.System.high_mode;
    SystemBuf[3] = RecStructData.System.aux_mode;
    SystemBuf[4] = RecStructData.System.out_mode;
    SystemBuf[5] = RecStructData.System.mixer_SourcedB;
    SystemBuf[6] = RecStructData.System.MainvolMuteFlg;
    SystemBuf[7] = RecStructData.System.theme;
    
    for (int i=0; i<8; i++) {
        [system_data addObject:[NSNumber numberWithUnsignedInteger:SystemBuf[i]]];
    }
    fileModel.data.system.system_data = system_data;
    
    //system_spk_type
    NSMutableArray *system_spk_type = [NSMutableArray array]; //48
    
    for (int i=0; i<8; i++) {
        SystemBuf[i]=RecStructData.System.none[i];
    }
    for (int i=0; i<8; i++) {
        SystemBuf[i+8]=RecStructData.System.high_Low_Set[i];
    }
    for (int i=0; i<16; i++) {
        SystemBuf[i+16]=RecStructData.System.high_Low_Set[i];
    }
    for (int i=0; i<16; i++) {
        SystemBuf[i+32]=RecStructData.System.out_spk_type[i];
    }

    for (int i=0; i<48; i++) {
        [system_spk_type addObject:[NSNumber numberWithUnsignedInteger:SystemBuf[i]]];
    }
    fileModel.data.system.system_spk_type = system_spk_type;
    
    //system_group_name
    NSMutableArray *system_group_name = [NSMutableArray array];//16
    for (int i=0; i<16; i++) {
        [system_group_name addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    fileModel.data.system.system_group_name = system_group_name;
    
    
    //group_name
    NSMutableArray *group_name = [NSMutableArray array];//16
    for (int i=0; i<16; i++) {
        [group_name addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    fileModel.data.group_name = group_name;
    
    
    NSDictionary *fileDict = fileModel.mj_keyValues;
    //    QIZLog(@"fileDict:%@",fileDict);

    return fileDict;
}



- (NSDictionary *)createAllJsonFileDictionary{
    
    AllGroupFileModel *allFileModel = [[AllGroupFileModel alloc] init];
    
    //本公司信息
    allFileModel.chs.company_brand = @"CHS";
    allFileModel.chs.company_briefing_en = @"The company was founded in 2013, is a focus on car DSP audio research and development program integrated company.";
    allFileModel.chs.company_briefing_zh = @"公司成立于2013年，是一家专注于车载DSP音频研究开发的方案集成型公司。";
    allFileModel.chs.company_contacts = @"Mr Qing";
    allFileModel.chs.company_name = @"广州市车厘子电子科技有限公司";
    allFileModel.chs.company_qq = @"QQ123456";
    allFileModel.chs.company_tel = @"020-87282169";
    allFileModel.chs.company_web = @"www.chschs.com";
    allFileModel.chs.company_weixin = @"CHSAUDIO";
    
    //客户公司信息
    allFileModel.client.company_brand = [NSString stringWithFormat:@"%d",AgentID]; //文件读取判断必须
    allFileModel.client.company_briefing_en = [self GetAgentIDNameEN:AgentID];
    allFileModel.client.company_briefing_zh=[self GetAgentIDName:AgentID];
    allFileModel.client.company_contacts=@"";
    allFileModel.client.company_name=[self GetAgentIDName:AgentID];
    allFileModel.client.company_qq=@"";
    allFileModel.client.company_tel=@"";
    allFileModel.client.company_web=@"";
    allFileModel.client.company_weixin=@"";

    
    //数据信息
    allFileModel.data_info.data_android_version = @"ANYJ-AV1.01";
    allFileModel.data_info.data_car_brand = @"";
    allFileModel.data_info.data_car_type = @"";
    allFileModel.data_info.data_eff_briefing = SEFFFile_name;
    allFileModel.data_info.data_user_tel = @"";
    allFileModel.data_info.data_user_name = @"";
    allFileModel.data_info.data_group_name = @"";
    allFileModel.data_info.data_group_num = @"0";
    allFileModel.data_info.data_user_mailbox = @"";
    allFileModel.data_info.data_ios_version = App_versions;
    allFileModel.data_info.data_json_version = Json_versions;
    allFileModel.data_info.data_machine_type = MAC_Type; //文件读取判断必须
    allFileModel.data_info.data_mcu_version = @"";
    allFileModel.data_info.data_pc_version = @"PC-?";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    allFileModel.data_info.data_upload_time = strDate;
    allFileModel.data_info.data_user_info = @"MC";
    allFileModel.data_info.data_head_data = HEAD_DATA;
    allFileModel.data_info.data_encryption_byte = 0;
    allFileModel.data_info.data_encryption_bool = false;
    
    allFileModel.fileType = @"complete";
    
    NSMutableArray *arrayDataModel = [NSMutableArray array];
    for(int usr=0;usr<=MAX_USE_GROUP;usr++){
        DataModel *dataModel = [[DataModel alloc] init];
        
        //group_name
        NSMutableArray *group_name = [NSMutableArray array];//16
        for (int i=0; i<16; i++) {
            [group_name addObject:[NSNumber numberWithUnsignedInteger:RecStructData.USER[usr].name[i]]];
        }
        dataModel.group_name = group_name;
        
        NSMutableArray *arrayMusic = [NSMutableArray array];
        
        for(int i=0;i<IN_CH_MAX;i++){
            NSMutableArray *arrayMusicTemp= [NSMutableArray array];
            for(int j=0;j<IN_LEN;j++){
                [arrayMusicTemp addObject:[NSNumber numberWithUnsignedInteger:JsonMacData.Data[usr].JIN.MusicJ[i][j]]];
            }
            [arrayMusic addObject:arrayMusicTemp];
        }
        dataModel.music.music = arrayMusic;
        
        NSMutableArray *arrayOutput = [NSMutableArray array];        
        for(int i=0;i<Output_CH_MAX;i++){
            NSMutableArray *arrayOutputTemp = [NSMutableArray array];
            for(int j=0;j<OUT_LEN;j++){
                [arrayOutputTemp addObject:[NSNumber numberWithUnsignedInteger:JsonMacData.Data[usr].JOUT.OutputJ[i][j]]];
            }
            [arrayOutput addObject:arrayOutputTemp];
        }
        dataModel.output.output = arrayOutput;
        
        [arrayDataModel addObject:dataModel];
        //NSLog(@"DataModel add:%d",usr);
    }
    allFileModel.data = arrayDataModel;
    //系统数据
    uint8 SystemBuf[16];
    //cur_password_data
    NSMutableArray *cur_password_data = [NSMutableArray array]; //8
    for (int i=0; i<8; i++) {
        [cur_password_data addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    allFileModel.system.cur_password_data = cur_password_data;
    
    //eff_group_name
    NSMutableArray *eff_group_name = [NSMutableArray array]; //8
    for (int i=0; i<16; i++) {
        [eff_group_name addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    allFileModel.system.eff_group_name = eff_group_name;
    
    //out_led
    NSMutableArray *out_led = [NSMutableArray array];
    for (int i=0; i<16; i++) {
        [out_led addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    allFileModel.system.out_led = out_led;
    
    //sound_delay_field
    NSMutableArray *sound_delay_field = [NSMutableArray array];//50
    for (int i=0; i<50; i++) {
        [sound_delay_field addObject:[NSNumber numberWithUnsignedInteger:RecStructData.SoundFieldSystem.SoundDelayField[i]]];
    }
    allFileModel.system.sound_delay_field = sound_delay_field;
    
    
    //PC_SOURCE_SET
    NSMutableArray *arraySystemTemp = [NSMutableArray array];
    SystemBuf[0] = RecStructData.System.input_source;
    SystemBuf[1] = RecStructData.System.mixer_source;
    SystemBuf[2] = RecStructData.System.InSwitch[0];
    SystemBuf[3] = RecStructData.System.InSwitch[1];
    SystemBuf[4] = RecStructData.System.InSwitch[2];
    SystemBuf[5] = RecStructData.System.InSwitch[3];
    SystemBuf[6] = RecStructData.System.InSwitch[4];
    SystemBuf[7] = RecStructData.System.none1;
    for (int i=0; i<8; i++) {
        [arraySystemTemp addObject:[NSNumber numberWithUnsignedInteger:SystemBuf[i]]];
    }
    allFileModel.system.pc_source_set = arraySystemTemp;
    
    //system_data
    NSMutableArray *system_data = [NSMutableArray array];//8
    SystemBuf[0] = RecStructData.System.main_vol;
    SystemBuf[1] = (RecStructData.System.main_vol >> 8) & 0xff;
    SystemBuf[2] = RecStructData.System.high_mode;
    SystemBuf[3] = RecStructData.System.aux_mode;
    SystemBuf[4] = RecStructData.System.out_mode;
    SystemBuf[5] = RecStructData.System.mixer_SourcedB;
    SystemBuf[6] = RecStructData.System.MainvolMuteFlg;
    SystemBuf[7] = RecStructData.System.theme;
    
    for (int i=0; i<8; i++) {
        [system_data addObject:[NSNumber numberWithUnsignedInteger:SystemBuf[i]]];
    }
    allFileModel.system.system_data = system_data;
    
    //system_spk_type
    NSMutableArray *system_spk_type = [NSMutableArray array]; //8
    for (int i=0; i<8; i++) {
        SystemBuf[i]=RecStructData.System.none[i];
    }
    for (int i=0; i<8; i++) {
        SystemBuf[i+8]=RecStructData.System.high_Low_Set[i];
    }
    for (int i=0; i<16; i++) {
        SystemBuf[i+16]=RecStructData.System.high_Low_Set[i];
    }
    for (int i=0; i<16; i++) {
         SystemBuf[i+32]=RecStructData.System.out_spk_type[i];
    }
    
    
    for (int i=0; i<48; i++) {
        [system_spk_type addObject:[NSNumber numberWithUnsignedInteger:SystemBuf[i]]];
    }
    allFileModel.system.system_spk_type = system_spk_type;
    
    //system_group_name
    NSMutableArray *system_group_name = [NSMutableArray array];//16
    for (int i=0; i<16; i++) {
        [system_group_name addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    allFileModel.system.system_group_name = system_group_name;
    
    NSDictionary *allFileDict = allFileModel.mj_keyValues;
    //    QIZLog(@"allFileDict:%@",allFileDict);
    
    return allFileDict;
}

//字典转Json字符串
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData){
        NSLog(@"Got an error: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
