# TYTextLimitTool
A tool to limit the type and length of text, support Objective-C and Swift.

You can find a Swift version here [TYTextInputLimitTool_Swift](https://github.com/HXHXT/TYTextInputLimitTool_Swift)

## Introduce

**If you don't want to write regular，textfield delegate，decimal count， insert space logic，try it！**

1. Support UITextField UITextView UILabel
2. Limit Text type include Chinese English Number
3. Limit Length 
4. Limit Decimal 
5. Limit Number with Space 

If you use TYTextLimitTool，the textfield delegate shouldn't be set again.

## Install

Add  TYTextLimitTool folders to your project.

## Usage

**Limit Chinese, English, Number, Length **

```
self.textField.textLimitTool.model = Chinese | English;
self.textField.textLimitTool.length = 10;

self.textField1.textLimitTool.model = Number | Decimal;
self.textField1.textLimitTool.length = 8;
```

**Limit Decimal, support setting the length of decimal points before and after**

```
self.textField2.textLimitTool.model = DecimalFraction;
self.textField2.textLimitTool.beforeDecimalLenth = 4;
self.textField2.textLimitTool.afterDecimalLenth = 3; 
```

**Limit Number with Space，support number or number array，support reverse，support check space after set text by code**

``` 
self.textField3.textLimitTool.model = NumberWithSpace;
self.textField3.textLimitTool.space = 4;
self.textField3.textLimitTool.reversed = false; // default is false
// check space after set text by code
self.textField3.text = @"123456789";
[self.textField3.textLimitTool checkSpace];
```

```
self.textField4.textLimitTool.model = NumberWithSpace;
self.textField4.textLimitTool.spaceList = @[@(2), @(3), @(4)];
// check space after set text by code
self.textField4.text = @"123456789";
[self.textField4.textLimitTool checkSpace];
```

**UITextView usage is similar to UITextField **

**UILabel mainly supports blank mode**

```
self.label.textLimitTool.model = NumberWithSpace;
self.label.textLimitTool.spaceList = @[@(2), @(3), @(4)];
self.label.text = @"123456789";
[self.label.textLimitTool checkSpace];
```

**You can find more examples in demo**