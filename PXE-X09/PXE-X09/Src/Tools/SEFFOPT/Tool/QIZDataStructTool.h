//
//  QIZDataStructTool.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/26.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacDefine.h"
#import "DataCommunication.h"

@interface QIZDataStructTool : NSObject
{
    @public
   }

/**
 * 数据模型
 */


-(NSDictionary *)createJsonFileDictionary;

//字典转Json字符串
+ (NSString*)convertToJSONData:(id)infoDict;

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//整机文件
-(NSDictionary *)createAllJsonFileDictionary;

@end
