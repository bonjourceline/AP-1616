//
//  QIZFileTool.m
//  ReNetTuning
//
//  Created by chsdsp on 2016/12/21.
//  Copyright © 2016年 dsp. All rights reserved.
//

#import "QIZFileTool.h"
#import "MacDefine.h"


#define PageMax (32*1024)
#define BUFMAX (32*30*1024)
@implementation QIZFileTool

/**
 * 返回保存到沙盒中的文件名称
 */
+(NSString *)backSaveBoxFileName:(NSString *)fileName fileType:(NSString *)fileType
{
    //沙盒目录
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";
    NSString *suffixName = fileType;
    appendFileName = [[slashName stringByAppendingString:fileName] stringByAppendingString:suffixName];
    
    //文件保存为jssh格式
    NSString *pStr = [path stringByAppendingString:appendFileName];
    
    return pStr;
}



+(void)writeJsonFileToBox:(NSString *)fileName fileContent:(NSString *)fileContent fileType:(NSString *)fileType
{
    //沙盒目录
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";
    NSString *suffixName = fileType;
    appendFileName = [[slashName stringByAppendingString:fileName] stringByAppendingString:suffixName];
    
    //文件保存为jssh格式
    NSString *pStr = [path stringByAppendingString:appendFileName];
    
    //以文本写入
    NSString *string = fileContent;
    
    //writeToFile
    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    [data writeToFile:pStr atomically:YES];
    
}


/**
 * 向沙盒写入文件 NSData
 */
+ (void)writeJsonFileToBox:(NSString *)fileName fileData:(NSData *)fileContent fileType:(NSString *)fileType
{
    //沙盒目录
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";
    NSString *suffixName = fileType;
    appendFileName = [[slashName stringByAppendingString:fileName] stringByAppendingString:suffixName];
    
    //文件保存为jssh格式
    NSString *pStr = [path stringByAppendingString:appendFileName];
    pStr = [NSString stringWithString:[pStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//
//    NSString *result = [[NSString alloc] initWithData:fileContent  encoding:NSUTF8StringEncoding];
//    fileContent = [result dataUsingEncoding: NSUTF8StringEncoding];
    [fileContent writeToFile:pStr atomically:YES];
    
 }



/**
 * 删除指定文件类型
 */
+(void)deleteAllJsonFileToBox:(NSString *)fileType
{
    NSString *extension = fileType;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];
        }
    }
}

/**
 * 删除指定名称文件
 */
+(void)deleteFileToBox:(NSString *)fileName
{
    NSFileManager *defauleManager = [NSFileManager defaultManager];
    NSString *thePath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = documentsDirectory;
    NSString *slashName = @"/";
    tempPath = [tempPath stringByAppendingString:slashName];
    thePath = [tempPath stringByAppendingString:fileName];
    [defauleManager removeItemAtPath:thePath error:nil];
//    QIZLog(@"temp目录内容：删除之后：%@",[defauleManager contentsOfDirectoryAtPath:tempPath error:nil]);
}

/**
 * 获取沙盒中所有文件 不区分类型
 */
+(NSArray *)getAllFileNames:(NSString *)dirName
{
    // 获得此程序的沙盒路径
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 获取Documents路径
    // [patchs objectAtIndex:0]
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:dirName];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
    return files;
}

/**
 * 遍历指定文件类型的所有文件
 */
+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    //默认获取documents
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    if (nil == dirPath) {
        dirPath = documentsDirectory;
    }
    
    NSArray *fileList = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil]
                         pathsMatchingExtensions:[NSArray arrayWithObject:type]];
    return fileList;
}

/**
 * 文件加密
 */
+(NSData *)encryptFilePath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [self exclusiveNSData:data];
}

/**
 * 文件解密
 */
+(NSData *)decryptFilePath:(NSString *)filePath withFileType:(NSString *)suffixName
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";
    appendFileName = [[slashName stringByAppendingString:filePath] stringByAppendingString:suffixName];
    
    NSLog(@"decryptFilePath filePath=%@",filePath);
    NSLog(@"decryptFilePath suffixName=%@",suffixName);
    NSLog(@"decryptFilePath appendFileName=%@",appendFileName);
    
    //文件保存为jssh格式
    NSString *pStr = [path stringByAppendingString:appendFileName];
    NSData *data = [NSData dataWithContentsOfFile:pStr];
    NSLog(@"decryptFilePath pStr=%@",pStr);
    
    return [self exclusiveNSData:data];

}

/**
 * 文件exclusive
 */
+(NSData *)exclusiveNSData:(NSData*)data
{
    Byte buf[BUFMAX];
    long nLen = data.length;
    long multiples = nLen / PageMax;
    long remainder = nLen % PageMax;
    
    NSLog(@"exclusiveNSData nLen=%ld",nLen);
    NSLog(@"exclusiveNSData multiples=%ld",multiples);
    NSLog(@"exclusiveNSData remainder=%ld",remainder);
    
    Byte *jsonByte = (Byte *)[data bytes];
    Byte tmp;
    Byte rawByte;
    
    for(long i=0;i<multiples;i++){
        for(long j=0;j<PageMax;j++){
            rawByte = jsonByte[i*PageMax +j];
            tmp = (Byte) (rawByte ^ j);
            buf[i*PageMax +j] = tmp;
        }
    }
    
    for (long j = 0; j < remainder; ++j) {
        rawByte = jsonByte[multiples*PageMax +j];
        tmp = (Byte) (rawByte ^ j);
        buf[multiples*PageMax +j] = tmp;
    }
    
    return [[NSData alloc] initWithBytes:buf length:nLen];
    
}


/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize
{
    
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}

/**
 * 获取DocumentDirectory文件全路径
 */
+(NSString *)fileFullPath:(NSString *)fileName withType:(NSString *)suffixName
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";

    appendFileName = [[slashName stringByAppendingString:fileName] stringByAppendingString:suffixName];
    
    //完整文件路径
    NSString *filePath = [path stringByAppendingString:appendFileName];
    
    return filePath;
}

/**
 * URL加载图片
 */
+ (UIImage *) imageFromURLString: (NSString *) urlstring
{
    // This call is synchronous and blocking
    return [UIImage imageWithData:[NSData
                                   dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}


/**
 * Path加载图片
 */
+ (UIImage *) imageFromPathString: (NSString *) pathString
{
    return [UIImage imageWithData:[NSData
                                   dataWithContentsOfFile:pathString]];
}

/**
 * Cahes目录加载图片
 */
+ (UIImage *) imageFromCachesPathFileName: (NSString *)fileName
{
    NSArray *pathCaches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSAllDomainsMask, YES);
    NSString *path = [pathCaches objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";
    NSString *suffixName = @".png";
    appendFileName = [[slashName stringByAppendingString:fileName] stringByAppendingString:suffixName];
    
    NSString *completePathStr = [path stringByAppendingString:appendFileName];

    return [UIImage imageWithData:[NSData
                                   dataWithContentsOfFile:completePathStr]];
}

#pragma mark ------缓存目录文件操作--------------

+ (void)writeFileToCacheDir:(NSString *)fileName fileData:(NSData *)fileContent fileType:(NSString *)fileType
{
    //沙盒目录
    NSArray *pathCaches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSAllDomainsMask, YES);
    NSString *path = [pathCaches objectAtIndex:0];
    
    NSString *appendFileName;
    NSString *slashName = @"/";
    NSString *suffixName = fileType;
    appendFileName = [[slashName stringByAppendingString:fileName] stringByAppendingString:suffixName];
    
    NSString *completePathStr = [path stringByAppendingString:appendFileName];

    [fileContent writeToFile:completePathStr atomically:YES];
}

/**
 * 返回路径最后的文件名称
 */
+ (NSString *)backLastPathName:(NSString *)path
{
    NSString *reviceName = [path lastPathComponent];
    NSString *fileName = nil;
    for (int i=0; i<reviceName.length; i++) {
        unichar c = [reviceName characterAtIndex:i];
        if (c == '.') {
//            QIZLog(@"i:%d",i);
            fileName = [reviceName substringToIndex:i];
        }
    }
    
    return fileName;
}


@end
