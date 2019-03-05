//
//  UITextField+TextLimit.m
//  WHPJSFinancial
//
//  Created by TY on 2017/4/27.
//  Copyright © 2017年 fine. All rights reserved.
//

#import "UITextField+TextLimit.h"
#import <objc/runtime.h>

@implementation UITextField (TextLimit)

- (void)setTextLimitTool:(TYTextLimitTool *)textLimitTool {
    objc_setAssociatedObject(self, @selector(textLimitTool), textLimitTool, OBJC_ASSOCIATION_RETAIN);
}

- (TYTextLimitTool *)textLimitTool {
    TYTextLimitTool *tool = objc_getAssociatedObject(self, @selector(textLimitTool));
    if (!tool) {
        tool = [[TYTextLimitTool alloc] init];
        self.delegate = tool;
        tool.object = self;
        [self addTarget:tool action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self setTextLimitTool:tool];
    }
    return tool;
}

@end
