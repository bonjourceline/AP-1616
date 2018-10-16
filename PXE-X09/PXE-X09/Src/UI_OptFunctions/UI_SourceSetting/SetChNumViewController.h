//
//  SetChNumViewController.h
//  PXE-X09
//
//  Created by celine on 2018/10/14.
//  Copyright © 2018 dsp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CHNUMTYPE) {
    CHNUMTYPE_input,
    CHNUMTYPE_output,
};
NS_ASSUME_NONNULL_BEGIN

@interface SetChNumViewController : UIViewController
-(void)setChNumType:(CHNUMTYPE)type;
@property (nonatomic,assign)CHNUMTYPE type;
@property (nonatomic,strong) void(^blackHome)(void);
@end

NS_ASSUME_NONNULL_END
