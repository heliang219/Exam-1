//
//  ECheckTextField.h
//  Exam
//
//  Created by yongqingguo on 2017/5/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ETextFieldType) {
    ETextFieldTypePhone, // 手机号
    ETextFieldTypeEmail, // 邮箱
    ETextFieldTypeIDCard, // 身份证
    ETextFieldTypeBankCard, // 银行卡
    ETextFieldTypeOther, // 其它
};

/**
 文本输入框，带格式检查功能
 */
@interface ECheckTextField : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UIFont *font;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,assign) BOOL secureTextEntry;
@property (nonatomic,assign) UIKeyboardType keyboardType;
@property (nonatomic,assign) UITextFieldViewMode clearButtonMode;
@property (nonatomic,strong) UIView *rightView; // 输入框右侧视图
@property (nonatomic,assign) BOOL immediatelyCheck; // 输入变化后立即检查输入格式是否符合，默认NO

/**
 格式检查

 @param tfType 输入框类型
 @return 如果输入内容格式与对应的输入框类型要求的格式一致，返回YES，否则范湖NO
 */
- (BOOL)check:(ETextFieldType)tfType;

@end
