//
//  QIZDatabaseTool.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/5.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "QIZDatabaseTool.h"
#import "FMDB.h"

#import "SEFFFile.h"

@implementation QIZDatabaseTool

static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"effectData.db"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表 t_login_sm
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_login_sm (id integer primary key autoincrement,name TEXT,password TEXT,re_password TEXT,auto_login TEXT,recently TEXT);"];
    
    // 2.创表 t_seffData
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_seffData (id integer primary key autoincrement,cid TEXT,uid TEXT,highData TEXT,version TEXT,type TEXT,ctime TEXT,brand TEXT,macModel TEXT,details TEXT,effName TEXT);"];
    
    // 2.创表 t_seffFile
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_seffFile (id integer primary key autoincrement,file_id TEXT,file_type TEXT,file_name TEXT,file_path TEXT,file_favorite TEXT,file_love TEXT,file_size TEXT,file_time TEXT,file_msg TEXT,data_user_name TEXT,data_machine_type TEXT,data_car_type TEXT,data_car_brand TEXT,data_group_name TEXT,data_upload_time TEXT,data_eff_briefing TEXT,list_sel TEXT,list_is_open TEXT,apply_time TEXT);"];
    
    // 2.创表 t_seffFile_recently
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_seffFile_recently (id integer primary key autoincrement,file_id TEXT,file_type TEXT,file_name TEXT,file_path TEXT,file_favorite TEXT,file_love TEXT,file_size TEXT,file_time TEXT,file_msg TEXT,data_user_name TEXT,data_machine_type TEXT,data_car_type TEXT,data_car_brand TEXT,data_group_name TEXT,data_upload_time TEXT,data_eff_briefing TEXT,list_sel TEXT,list_is_open TEXT);"];
    
}

//增
+ (BOOL)addSingleEffectData:(SEFFFile *)effFile
{
//    [_db executeUpdateWithFormat:@"INSERT INTO t_shop(name, price) VALUES (%@, %f);", shop.name, shop.price];

//    NSMutableArray *effectArrayM = [NSMutableArray array];
    
   return [_db executeUpdateWithFormat:@"INSERT INTO t_seffFile(file_id,file_type,file_name,file_path,file_favorite,file_love,file_size,file_time,file_msg,data_user_name,data_machine_type,data_car_type,data_car_brand,data_group_name,data_upload_time,data_eff_briefing,list_sel,list_is_open,apply_time) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@);",effFile.file_id,effFile.file_type,effFile.file_name,effFile.file_path,effFile.file_favorite,effFile.file_love,effFile.file_size,effFile.file_time,effFile.file_msg,effFile.data_user_name,effFile.data_machine_type,effFile.data_car_type,effFile.data_car_brand,effFile.data_group_name,effFile.data_upload_time,effFile.data_eff_briefing,effFile.list_sel,effFile.list_is_open,effFile.apply_time
     ];
    
//    return effectArrayM;
    
//    INSERT INTO "t_seffFile" VALUES (1, 'file_id', 'single', 'fuck', '/storage/sdcard1/CHS/leon.android.chs_yj_dap460_x2_net/SoundEff/fuck.jssh', 0, 0, 200, '2016-11-22 11:06:00', 'file_msg', 13726268191, '', '辉腾', '', 'fuck', '2016-11-22 11:06:00', 'ggfhhgffghj', 0, 0);
    
}

//删除
+ (BOOL)deleteSingleRecord:(NSString *)nID
{
    //删除数据
    return [_db executeUpdate:@"DELETE FROM t_seffFile WHERE id = ?", nID];
}

//查询
+ (NSMutableArray *)queryAllData
{// 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_seffFile;"];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}

//收藏查询
+ (NSMutableArray *)queryFilefavorite:(NSString *)condition
{// 得到结果集
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE file_favorite = '%@'",condition];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}

+ (NSMutableArray *)queryFilelove:(NSString *)condition
{// 得到结果集
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE file_love = '%@'",condition];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}


+ (NSMutableArray *)queryApplyTimeAllData
{// 得到结果集
    //SELECT * FROM t_seffFile WHERE apply_time != ''
    //SELECT  apply_time   FROM t_seffFile  order by date(apply_time) desc,  time(apply_time) desc limit 0,50 排序
//    SELECT  *   FROM t_seffFile WHERE apply_time != '' order by date(apply_time) desc,  time(apply_time) desc limit 0,50
    
    NSString *sqlStr = @"SELECT * FROM t_seffFile WHERE apply_time != '' order by date(apply_time) desc,  time(apply_time) desc limit 0,50";
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}


/**
 *  查询是否存在文件名
 */
+ (BOOL)queryExistFileName:(NSString *)name
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE file_name = '%@'",name];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    while (set.next) {
        return TRUE;
    }

    return FALSE;
}


//修改
+ (BOOL)updateFavoriteFieldValue:(NSString *)fieldValue where:(NSString *)name
{
    return [_db executeUpdate:@"UPDATE t_seffFile SET file_favorite = ? WHERE data_group_name = ? ",fieldValue,name];
    
}

+ (BOOL)updateLoveFieldValue:(NSString *)fieldValue where:(NSString *)name
{
    return [_db executeUpdate:@"UPDATE t_seffFile SET file_love = ? WHERE data_group_name = ? ",fieldValue,name];
    
}

+ (BOOL)updateApplyTimeFieldValue:(NSString *)fieldValue where:(NSString *)name
{
    return [_db executeUpdate:@"UPDATE t_seffFile SET apply_time = ? WHERE data_group_name = ? ",fieldValue,name];
    
}


+ (BOOL)updateRowCheckFieldValue:(NSString *)fieldValue where:(NSString *)name
{
    return [_db executeUpdate:@"UPDATE t_seffFile SET list_sel = ? WHERE data_group_name = ? ",fieldValue,name];
    
}



//按照组名称 全排序
+ (NSMutableArray *)queryAllDataSortMode:(NSString *)sortMode
{// 得到结果集
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile ORDER BY data_group_name %@",sortMode];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}

//按照组名称 条件:喜欢
+ (NSMutableArray *)queryFilefavorite:(NSString *)condition SortMode:(NSString *)sortMode
{// 得到结果集
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE file_favorite = '%@' ORDER BY data_group_name %@",condition,sortMode];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}

+ (NSMutableArray *)queryFilelove:(NSString *)condition SortMode:(NSString *)sortMode
{// 得到结果集
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE file_love = '%@' ORDER BY data_group_name %@",condition,sortMode];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}

/**
*按照组名称 条件:最近 保留
*参数：ASC/DESC
*/
+ (NSMutableArray *)queryApplyTimeAllDataSortMode:(NSString *)sortMode
{// 得到结果集
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE apply_time != '' order by date(apply_time) %@,  time(apply_time) %@ limit 0,50",sortMode,sortMode];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}


//模糊查询
+ (NSMutableArray *)queryLikeName:(NSString *)name
{// 得到结果集
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_seffFile WHERE data_group_name LIKE '%%%@%%'",name];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    // 不断往下取数据
    NSMutableArray *effectArrayM = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        SEFFFile *eff = [[SEFFFile alloc] init]; //19个字段
        eff.autoID = [set intForColumn:@"id"];
        eff.file_id = [set stringForColumn:@"file_id"];
        eff.file_type = [set stringForColumn:@"file_type"];
        eff.file_name = [set stringForColumn:@"file_name"];
        eff.file_path = [set stringForColumn:@"file_path"];
        eff.file_favorite = [set stringForColumn:@"file_favorite"];
        eff.file_love = [set stringForColumn:@"file_love"];
        eff.file_size = [set stringForColumn:@"file_size"];
        eff.file_time = [set stringForColumn:@"file_time"];
        eff.file_msg = [set stringForColumn:@"file_msg"];
        eff.data_user_name = [set stringForColumn:@"data_user_name"];
        eff.data_machine_type = [set stringForColumn:@"data_machine_type"];
        eff.data_car_type = [set stringForColumn:@"data_car_type"];
        eff.data_car_brand = [set stringForColumn:@"data_car_brand"];
        eff.data_group_name = [set stringForColumn:@"data_group_name"];
        eff.data_upload_time = [set stringForColumn:@"data_upload_time"];
        eff.data_eff_briefing = [set stringForColumn:@"data_eff_briefing"];
        eff.list_sel = [set stringForColumn:@"list_sel"];
        eff.list_is_open = [set stringForColumn:@"list_is_open"];
        eff.apply_time = [set stringForColumn:@"apply_time"];
        [effectArrayM addObject:eff];
    }
    return effectArrayM;
    
}


@end
