//
//  SpkViewController.h
//  PXE-X09
//
//  Created by celine on 2018/10/11.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SPKTYPE) {
    SPKTYPE_OUT,
    SPKTYPE_IN,
};
NS_ASSUME_NONNULL_BEGIN

@interface SpkViewController : UIViewController
@property (nonatomic,assign)SPKTYPE myType;
@property(nonatomic,strong)void (^dismissBlock)(void);
@end

NS_ASSUME_NONNULL_END
