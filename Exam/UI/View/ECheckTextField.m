//
//  ECheckTextField.m
//  Exam
//
//  Created by yongqingguo on 2017/5/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ECheckTextField.h"
#import "EUtils.h"

@interface ETextField : UITextField

@end

@implementation ETextField

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

@end

@implementation ECheckTextField
{
    UITextField *_tf;
    UILabel *_lbl;
    
    BOOL _checkFail;
    ETextFieldType _type;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIFont *)font {
    return _tf.font;
}

- (void)setFont:(UIFont *)font {
    _tf.font = font;
}

- (NSString *)text {
    return _tf.text;
}

- (void)setText:(NSString *)text {
    _tf.text = text;
}

- (UIColor *)textColor {
    return _tf.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _tf.textColor = textColor;
}

- (BOOL)secureTextEntry {
    return _tf.secureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _tf.secureTextEntry = secureTextEntry;
}

- (UIKeyboardType)keyboardType {
    return _tf.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _tf.keyboardType = keyboardType;
}

- (UITextFieldViewMode)clearButtonMode {
    return _tf.clearButtonMode;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    _tf.clearButtonMode = clearButtonMode;
}

- (UIView *)rightView {
    return _tf.rightView;
}

- (void)setRightView:(UIView *)rightView {
    if (rightView) {
        _tf.rightViewMode = UITextFieldViewModeAlways;
        _tf.rightView = rightView;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect realFrame = CGRectMake(frame.origin.x, frame.origin.y - 20, frame.size.width, frame.size.height + 20);
    self = [super initWithFrame:realFrame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 100, 0, 100, 10)];
        _lbl.font = kTinyFont;
        _lbl.text = @"格式不正确";
        _lbl.textColor = RGBCOLOR(211, 69, 69);
        _lbl.textAlignment = NSTextAlignmentRight;
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.hidden = YES;
        [self addSubview:_lbl];
        
        _tf = [[ETextField alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height)];
        _tf.layer.cornerRadius = 5.f;
        _tf.layer.masksToBounds = YES;_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tf.leftViewMode = UITextFieldViewModeAlways;
        _tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
        [_tf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_tf];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_checkFail) {
        _tf.layer.borderColor = RGBCOLOR(211, 69, 69).CGColor;
        _tf.layer.borderWidth = 1.f;
        _tf.textColor = RGBCOLOR(211, 69, 69);
        _lbl.hidden = NO;
    } else {
        _tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tf.layer.borderWidth = 1.f;
        _tf.textColor = [UIColor blackColor];
        _lbl.hidden = YES;
    }
    [super drawRect:rect];
}

- (BOOL)check:(ETextFieldType)tfType {
    _type = tfType;
    if (!_tf.text) {
        _checkFail = YES;
    }
    switch (tfType) {
        case ETextFieldTypePhone:
        {
            _checkFail = ![EUtils IsPhoneNumber:_tf.text];
        }
            break;
        case ETextFieldTypeEmail:
        {
            _checkFail = ![EUtils IsEmailAdress:_tf.text];
        }
            break;
        case ETextFieldTypeIDCard:
        {
            _checkFail = ![EUtils IsIdentityCard:_tf.text];
        }
            break;
        case ETextFieldTypeBankCard:
        {
            _checkFail = ![EUtils IsBankCard:_tf.text];
        }
            break;
        case ETextFieldTypeOther:
        {
            _checkFail = NO;
        }
            break;
        default:
            _checkFail = YES;
            break;
    }
    // 重绘
    [self setNeedsDisplay];
    return !_checkFail;
}

- (void)textFieldChanged:(UITextField *)textField {
    if (self.immediatelyCheck) {
        if (textField.text && ![textField.text isEqualToString:@""]) {
            [self check:_type];
        } else {
            _checkFail = NO;
            [self setNeedsDisplay];
        }
    }
}

@end
