//
//  TYTextLimitTool.h
//  WHPJSFinancial
//
//  Created by TY on 2017/4/27.
//  Copyright © 2017年 fine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^UITextChangeBlock)(NSString *text);
typedef NS_ENUM(NSUInteger, TYTextLimitModel) {
    // 以下可组合
    Number = 0x0001,             // 数字
    English = 0x0002,            // 英文
    Chinese = 0x0004,            // 汉字
    Decimal = 0x0008,            // 小数点
    // 以下均为独立模式
    DecimalFraction = 0x0010,    // 小数 - 支持设置小数点前长度和小数点后长度
    NumberWithSpace = 0x0080,    // 数字插空格 - 需要设置 间隔数 或者 间隔数组
};

@interface TYTextLimitTool : NSObject <UITextFieldDelegate, UITextViewDelegate>

#pragma mark --------------public--------------
// 字符判断
@property (assign, nonatomic) TYTextLimitModel model;

// 长度判断
@property (assign, nonatomic) NSInteger length;

// 小数判断 - 小数点前长度和小数点后长度
@property (assign, nonatomic) NSInteger beforeDecimalLenth;
@property (assign, nonatomic) NSInteger afterDecimalLenth;

// 数字插空格 - 插空格位置,比如希望把123456789分成1234 5678 9，这里就传4
@property (assign, nonatomic) NSInteger space;
// 数字插空格 - 正向还是反向，比如希望把123456789分成1 2345 6789，这里就传true
@property (assign, nonatomic) BOOL reversed;
// 根据数组加空格,数组中为分段标准，比如希望把123456789分成123 4567 89，数组就传[@(3),@(4),@(2)]
@property (nonatomic, strong) NSArray *spaceList;

// 文字改变回调，过滤了待选的情况
@property (copy, nonatomic) UITextChangeBlock textChangeBlock;
// 文字输入完毕回调
@property (copy, nonatomic) UITextChangeBlock textReturnBlock;

// 手动验证-在给textfield/textview/label设置了text后，如果想要插空格可以调用这个方法，此处不再验证其他内容。
- (void)checkSpace;

#pragma mark --------------provite--------------
@property (nonatomic, weak) NSObject *object;
- (void)textFieldTextDidChange:(UITextField *)textField;

@end
