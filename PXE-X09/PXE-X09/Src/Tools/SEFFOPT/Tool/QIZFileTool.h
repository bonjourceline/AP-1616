//
//  QIZFileTool.h
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/21.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QIZFileTool : NSObject

/**
 * 返回保存到沙盒中的文件名称
 */
+(NSString *)backSaveBoxFileName:(NSString *)fileName fileType:(NSString *)fileType;

/**
 * 向沙盒写入文件 NSString
 */
+ (void)writeJsonFileToBox:(NSString *)fileName fileContent:(NSString *)fileContent fileType:(NSString *)fileType;

/**
 * 向沙盒写入文件 NSData
 */
+ (void)writeJsonFileToBox:(NSString *)fileName fileData:(NSData *)fileContent fileType:(NSString *)fileType;

/**
 * 删除指定文件类型
 */
+ (void)deleteAllJsonFileToBox:(NSString *)fileType;

/**
 * 删除指定名称文件
 */
+ (void)deleteFileToBox:(NSString *)fileName;


/**
 * 获取沙盒中所有文件 不区分类型
 */
+ (NSArray *)getAllFileNames:(NSString *)dirName;


/**
 * 遍历指定文件类型的所有文件
 */
+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;


/**
 * 文件加密
 */
+(NSData *)encryptFilePath:(NSString*)filePath;

/**
 * 文件解密
 */
+(NSData *)decryptFilePath:(NSString *)filePath withFileType:(NSString *)suffixName;


+(NSData *)exclusiveNSData:(NSData*)data;


/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;

/**
 * 获取DocumentDirectory文件全路径
 */
+(NSString *)fileFullPath:(NSString *)fileName withType:(NSString *)suffixName;

/**
 * URL加载图片
 */
+ (UIImage *) imageFromURLString: (NSString *) urlstring;

/**
 * Path加载图片
 */
+ (UIImage *) imageFromPathString: (NSString *) pathString;

/**
 * Cahes目录加载图片
 */
+ (UIImage *) imageFromCachesPathFileName: (NSString *)fileName;

#pragma mark ------缓存目录文件操作--------------
+ (void)writeFileToCacheDir:(NSString *)fileName fileData:(NSData *)fileContent fileType:(NSString *)fileType;

/**
 * 返回路径最后的文件名称
 */
+ (NSString *)backLastPathName:(NSString *)path;


@end
