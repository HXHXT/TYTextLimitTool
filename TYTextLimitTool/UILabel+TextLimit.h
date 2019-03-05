//
//  UILabel+TextLimit.h
//  OCDemo
//
//  Created by anfeng on 2019/2/28.
//  Copyright © 2019 anfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextLimitTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TextLimit)

@property (strong, nonatomic) TYTextLimitTool *textLimitTool;

@end

NS_ASSUME_NONNULL_END
