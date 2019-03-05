//
//  UITextView+TextLimit.m
//  TY_WuHanPJJY
//
//  Created by TY on 2017/5/15.
//  Copyright © 2017年 TY. All rights reserved.
//

#import "UITextView+TextLimit.h"
#import <objc/runtime.h>

@implementation UITextView (TextLimit)

- (void)setTextLimitTool:(TYTextLimitTool *)textLimitTool {
    objc_setAssociatedObject(self, @selector(textLimitTool), textLimitTool, OBJC_ASSOCIATION_RETAIN);
}

- (TYTextLimitTool *)textLimitTool {
    TYTextLimitTool *tool = objc_getAssociatedObject(self, @selector(textLimitTool));
    if (!tool) {
        tool = [[TYTextLimitTool alloc] init];
        self.delegate = tool;
        tool.object = self;
        [self setTextLimitTool:tool];
    }
    return tool;
}

@end
