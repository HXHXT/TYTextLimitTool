//
//  UILabel+TextLimit.m
//  OCDemo
//
//  Created by anfeng on 2019/2/28.
//  Copyright © 2019 anfeng. All rights reserved.
//

#import "UILabel+TextLimit.h"
#import <objc/runtime.h>

@implementation UILabel (TextLimit)

- (void)setTextLimitTool:(TYTextLimitTool *)textLimitTool {
    objc_setAssociatedObject(self, @selector(textLimitTool), textLimitTool, OBJC_ASSOCIATION_RETAIN);
}

- (TYTextLimitTool *)textLimitTool {
    TYTextLimitTool *tool = objc_getAssociatedObject(self, @selector(textLimitTool));
    if (!tool) {
        tool = [[TYTextLimitTool alloc] init];
        tool.object = self;
        [self setTextLimitTool:tool];
    }
    return tool;
}

@end
