//
//  TYTextLimitTool.m
//  WHPJSFinancial
//
//  Created by TY on 2017/4/27.
//  Copyright © 2017年 fine. All rights reserved.
//

#import "TYTextLimitTool.h"

@interface TYTextLimitTool ()

/** 输入时验证 */
@property (copy, nonatomic) NSString *textRegex;
/** 确认输入后验证 */
@property (copy, nonatomic) NSString *textConfirmRegex;
// space个数
@property (nonatomic, assign) NSInteger spaceLenth;

@end

@implementation TYTextLimitTool

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - 输入时验证
/**
 *  textField
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self checkTextWithOldText:textField.text newText:string object:textField];
}

/**
 *  textView
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [self checkTextWithOldText:textView.text newText:text object:textView];
}

- (BOOL)checkTextWithOldText:(NSString *)oldText newText:(NSString *)newText object:(NSObject *)object {
    // 删除
    if ([newText isEqualToString:@""]) {
        if (self.model > 0 && ((self.model & NumberWithSpace) == NumberWithSpace)) {
            if ([oldText hasSuffix:@" "] && oldText.length > 1) {
                [object setValue:[oldText substringToIndex:oldText.length - 2] forKey:@"text"];
                return NO;
            }
        }
        return YES;
    }
    if (self.model > 0) {
        // 正则判断
        if (![self checkPredWithRegex:self.textRegex text:newText]) {
            return NO;
        }
        // 小数位数判断
        if (![self checkDecimalFractionWithOldText:oldText newText:newText]) {
            return NO;
        }
        // 插空格判断
        if (![self checkNumberWithSpaceWithOldText:oldText newText:newText object:object]) {
            // 长度判断
            [self checkLengthWithText:[object valueForKey:@"text"] object:object];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 确认输入后验证
// textField
- (void)textFieldTextDidChange:(UITextField *)textField {
    [self checkTextWith:textField.text markedTextRange:textField.markedTextRange object:textField];
}

// textView
- (void)textViewDidChange:(UITextView *)textView {
    [self checkTextWith:textView.text markedTextRange:textView.markedTextRange object:textView];
}

- (void)checkTextWith:(NSString *)text markedTextRange:(UITextRange *)markedTextRange object:(NSObject *)object {
    if (!markedTextRange) {
        // 长度判断
        [self checkLengthWithText:text object:object];
        
        // 中文判断
        if ((self.model & Chinese) == Chinese && text.length && !((self.model & English) == English)) {
            if (![self checkPredWithRegex:self.textConfirmRegex text:text]) {
                NSString *str = [text stringByReplacingOccurrencesOfString:@"[a-zA-Z]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
                [object setValue:str forKey:@"text"];
            }
        }
        if (self.textChangeBlock) {
            self.textChangeBlock(text);
        }
    }
}

#pragma mark --------------手动验证--------------
- (void)checkSpace {
    if (self.model > 0 && self.object) {
        NSString *text = [self.object valueForKey:@"text"];
        // 插空格判断
        [self checkNumberWithSpaceWithOldText:@"" newText:text object:self.object];
    }
}

#pragma mark --------------check方法--------------
// 正则
- (BOOL)checkPredWithRegex:(NSString *)Regex text:(NSString *)text {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if(![pred evaluateWithObject:text]){
        return NO;
    }
    return YES;
}

// 小数位数判断
- (BOOL)checkDecimalFractionWithOldText:(NSString *)oldText newText:(NSString *)newText {
    if ((self.model & DecimalFraction) == DecimalFraction && (self.afterDecimalLenth > 0) && (self.beforeDecimalLenth > 0)) {
        if ([oldText containsString:@"."]) { // 已经包含了小数点了
            if ([newText isEqualToString:@"."]) {
                return NO;
            }
            NSInteger index = [oldText rangeOfString:@"."].location;
            NSString *decimalFraction = [oldText substringFromIndex:index + 1];
            if (decimalFraction.length >= self.afterDecimalLenth) {
                return NO;
            }
        } else {
            if (!oldText.length && ([newText isEqualToString:@"."] || [newText isEqualToString:@"0"])) {
                return NO;
            } else if ((oldText.length >= self.beforeDecimalLenth) && ![newText isEqualToString:@"."]) {
                return NO;
            }
        }
    }
    return YES;
}

// 插空格判断
- (BOOL)checkNumberWithSpaceWithOldText:(NSString *)oldText newText:(NSString *)newText object:(NSObject *)object {
    if ((self.model & NumberWithSpace) == NumberWithSpace) {
        NSMutableString *string = [[oldText stringByAppendingString:newText] stringByReplacingOccurrencesOfString:@" " withString:@""].mutableCopy;
        NSInteger index = 0;
        if ((self.space > 0) && self.reversed) {
            index = string.length % self.space;
            if ((index > 0) && (string.length / self.space)) {
                [string insertString:@" " atIndex:index];
                index++;
            }
        }
        int spaceListIndex = 0;
        while (1) {
            if (self.spaceList != nil) {
                if (self.spaceList.count > spaceListIndex) {
                    NSNumber *value = self.spaceList[spaceListIndex];
                    index += value.intValue;
                    spaceListIndex++;
                } else {
                    break;
                }
            } else if (self.space > 0) {
                index += self.space;
            }
            if (string.length <= index) {
                break;
            }
            [string insertString:@" " atIndex:index];
            index += 1;
        }
        [object setValue:string forKey:@"text"];
        return NO;
    }
    return YES;
}

// 长度判断
- (BOOL)checkLengthWithText:(NSString *)text object:(NSObject *)object {
    if (self.length > 0) {
        if (text.length > self.length + self.spaceLenth) {
            [object setValue:[text substringToIndex:self.length + self.spaceLenth] forKey:@"text"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 文字输入完毕回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textReturnBlock) {
        self.textReturnBlock(textField.text);
    }
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textReturnBlock) {
        self.textReturnBlock(textView.text);
    }
}

#pragma mark - setter
/** 初始化正则 */
- (void)setModel:(TYTextLimitModel)model {
    _model = model;
    
    NSMutableString *textRegex = [NSMutableString string];
    NSMutableString *textConfirmRegex = [NSMutableString string];
    
    if ((self.model & DecimalFraction) == DecimalFraction) { // 小数模式
        [textConfirmRegex appendString:@"0-9."];
    } else if ((self.model & NumberWithSpace) == NumberWithSpace) { // 数字插空格模式
        [textConfirmRegex appendString:@"0-9\\s"];
    } else {
        if ((self.model & Chinese) == Chinese) {
            [textConfirmRegex appendString:@"\u4e00-\u9fa5"];
        }
        if ((self.model & English) == English) {
            [textConfirmRegex appendString:@"a-zA-Z"];
        }
        if ((self.model & Number) == Number) {
            [textConfirmRegex appendString:@"0-9"];
        }
        if ((self.model & Decimal) == Decimal) {
            [textConfirmRegex appendString:@"."];
        }
    }
    textRegex = textConfirmRegex.mutableCopy;
    if ((self.model & Chinese) == Chinese) {
        [textRegex appendString:@"a-zA-Z➋➌➍➎➏➐➑➒"];
    }
    self.textRegex = [NSString stringWithFormat:@"[%@]+", textRegex];
    self.textConfirmRegex = [NSString stringWithFormat:@"[%@]+", textConfirmRegex];
}

- (void)setSpace:(NSInteger)space {
    _space = space;
    
    if (self.length > 0 && self.spaceLenth == 0) {
        self.spaceLenth += (self.length - 1) / self.space;
    }
}

- (void)setSpaceList:(NSArray *)spaceList {
    _spaceList = spaceList;
    
    int count = 0;
    for (NSNumber *i in spaceList) {
        count += i.intValue;
    }
    self.length = count;
    self.spaceLenth = self.spaceList.count - 1;
}

- (void)setLength:(NSInteger)length {
    _length = length;
    
    if (self.space > 0 && self.spaceLenth == 0) {
        self.spaceLenth += (self.length - 1) / self.space;
    }
}


@end
