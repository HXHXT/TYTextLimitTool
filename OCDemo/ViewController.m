//
//  ViewController.m
//  Demo
//
//  Created by TY on 2019/2/15.
//  Copyright © 2019 TY. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+TextLimit.h"
#import "UITextView+TextLimit.h"
#import "UILabel+TextLimit.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    #pragma mark --------------Chinese，English，Number，Decimal等类型可以自由组合--------------
    self.textField.textLimitTool.model = Chinese | English;
    self.textField.textLimitTool.length = 10;
    self.textField.textLimitTool.textChangeBlock = ^(NSString *text) {
        NSLog(@"%@", text);
    };
    self.textField.textLimitTool.textReturnBlock = ^(NSString *text) {
        NSLog(@"%@", text);
    };
    
    self.textField1.textLimitTool.model = Number | Decimal;
    self.textField1.textLimitTool.length = 8;
    
    #pragma mark --------------小数模式，不能与其他模式组合，支持设置小数点前后长度--------------
    self.textField2.textLimitTool.model = DecimalFraction;
    self.textField2.textLimitTool.beforeDecimalLenth = 4; // 小数点前4位
    self.textField2.textLimitTool.afterDecimalLenth = 3; // 小数点后3位

    #pragma mark --------------数字插空格模式，支持两种插空格方式--------------
    // 主要用于银行卡输入等情况，不能与其他模式组合，需要设置 间隔数 或 间隔数组 (同时设置的话只有间隔数组生效)
    self.textField3.textLimitTool.model = NumberWithSpace; // 间隔数
    self.textField3.textLimitTool.space = 4; // 间隔数为4,比如输入123456789，则显示1234 5678 9
    self.textField3.textLimitTool.reversed = false; // 是否反向，默认为false，如果设置成true，则输入123456789会显示1 2345 6789
    self.textField3.textLimitTool.length = 9; // 长度限制，不包含空格
    // 插空格模式可以手动checkSpace，便于给服务器返回的数据加空格
    self.textField3.text = @"123456789";
    [self.textField3.textLimitTool checkSpace];
    
    // 间隔数组
    self.textField4.textLimitTool.model = NumberWithSpace;
    self.textField4.textLimitTool.spaceList = @[@(2), @(3), @(4)]; // 间隔数组，输入123456789，则显示12 345 6789，会自动加上长度限制为9（2+3+4）个字符
    // 插空格模式可以手动checkSpace，便于给服务器返回的数据加空格
    self.textField4.text = @"123456789";
    [self.textField4.textLimitTool checkSpace];
    
    #pragma mark --------------textview用法类似，这里只举一个简单例子--------------
    self.textView.textLimitTool.model = Chinese | English;
    self.textView.textLimitTool.length = 20;
    
    #pragma mark --------------label主要是支持NumberWithSpace的功能--------------
    self.label.textLimitTool.model = NumberWithSpace;
    self.label.textLimitTool.spaceList = @[@(2), @(3), @(4)];
    self.label.text = @"123456789";
    [self.label.textLimitTool checkSpace];
    
    // 添加触摸停止输入
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHasTouched)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewHasTouched {
    [self.view endEditing:YES];
}

@end
