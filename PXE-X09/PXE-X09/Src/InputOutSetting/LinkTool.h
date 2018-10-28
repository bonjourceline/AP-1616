//
//  LinkTool.h
//  PXE-X09
//
//  Created by celine on 2018/10/24.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LinkManager [LinkTool shareManager]
NS_ASSUME_NONNULL_BEGIN

@interface LinkTool : NSObject
@property(nonatomic,strong)NSMutableArray *inAutoLinks;
//@property(nonatomic,strong)NSMutableArray *inLinks;
@property(nonatomic,strong)NSMutableArray *outAutoLinks;
//@property(nonatomic,strong)NSMutableArray *outLinks;
+ (instancetype)shareManager;
@end

NS_ASSUME_NONNULL_END
