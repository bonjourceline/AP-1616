//
//  QIZDatabaseTool.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/5.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SEFFFile;

@interface QIZDatabaseTool : NSObject

//增加
+ (BOOL)addSingleEffectData:(SEFFFile *)effectData;

//删除
+ (BOOL)deleteSingleRecord:(NSString *)nID;

//查询
+ (NSMutableArray *)queryAllData;

//条件查询
+ (NSMutableArray *)queryFilefavorite:(NSString *)condition;

//条件查询
+ (NSMutableArray *)queryFilelove:(NSString *)condition;

//最近使用条件查询
+ (NSMutableArray *)queryApplyTimeAllData;


//查询文件名是否存在
+ (BOOL)queryExistFileName:(NSString *)name;

//更新收藏类型
+ (BOOL)updateFavoriteFieldValue:(NSString *)fieldValue where:(NSString *)name;

//更新喜欢类型
+ (BOOL)updateLoveFieldValue:(NSString *)fieldValue where:(NSString *)name;

//更新应用时间类型
+ (BOOL)updateApplyTimeFieldValue:(NSString *)fieldValue where:(NSString *)name;

//更新行选中状态
+ (BOOL)updateRowCheckFieldValue:(NSString *)fieldValue where:(NSString *)name;







//按照组名称 全排序
+ (NSMutableArray *)queryAllDataSortMode:(NSString *)sortMode;

//按照组名称 条件:收藏
+ (NSMutableArray *)queryFilefavorite:(NSString *)condition SortMode:(NSString *)sortMode;

//按照组名称 条件:喜欢
+ (NSMutableArray *)queryFilelove:(NSString *)condition SortMode:(NSString *)sortMode;

//按照组名称 条件:最近
+ (NSMutableArray *)queryApplyTimeAllDataSortMode:(NSString *)sortMode;

//模糊查询
+ (NSMutableArray *)queryLikeName:(NSString *)name;



@end
