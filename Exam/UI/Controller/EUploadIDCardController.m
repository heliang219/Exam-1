//
//  EUploadIDCardController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EUploadIDCardController.h"
#import "EImagePickerController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Additions.h"
#import "UINavigationBar+Awesome.h"
#import "EApiClient.h"
#import "NSString+Additions.h"
#import "UIButton+WebCache.h"

@interface EUploadIDCardController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *selectedTopImage; // 选择的正面图片
    UIImage *selectedBottomImage; // 选择的反面图片
    BOOL isTopImage;
    
    UIButton *topBtn;
    UIButton *bottomBtn;
    UIButton *submitBtn;
}

@end

@implementation EUploadIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    [self initScrollView];
    
    // 身份证已经上传
    NSString *frontUrl = [[kUserDefaults objectForKey:kCertificateFront] realString];
    NSString *backUrl = [[kUserDefaults objectForKey:kCertificateBack] realString];
    if (frontUrl && backUrl) {
        submitBtn.hidden = YES;
    } else {
        submitBtn.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)initScrollView {
    UIScrollView *scrollPane = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    scrollPane.contentSize = CGSizeMake(scrollPane.bounds.size.width, scrollPane.bounds.size.height - kNavigationBarHeight);
    scrollPane.showsVerticalScrollIndicator = NO;
    scrollPane.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollPane];
    
    CGFloat originX = 83.5 * kFrameWidth / 375.f;
    CGFloat originY = kEPadding * 3;
    
    CGFloat blockWidth = kFrameWidth - originX * 2;
    CGFloat blockHeight = 116.f * kFrameHeight / 667.f;
    CGFloat lblWidth = blockWidth;
    CGFloat lblHeight = 20.f;
    
    UILabel *topLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, lblWidth, lblHeight)];
    topLbl.text = @"上传身份证正面";
    topLbl.textColor = [UIColor blackColor];
    topLbl.textAlignment = NSTextAlignmentCenter;
    topLbl.font = kSmallFont;
    [scrollPane addSubview:topLbl];
    
    originY += lblHeight + kEPadding * 2;
    topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame = CGRectMake(originX, originY, blockWidth, blockHeight);
    [topBtn setBackgroundImage:IMAGE_BY_NAMED(@"add") forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:topBtn];
    
    originY += blockHeight + kEPadding * 4;
    UILabel *bottomLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, lblWidth, lblHeight)];
    bottomLbl.text = @"上传身份证反面";
    bottomLbl.textColor = [UIColor blackColor];
    bottomLbl.textAlignment = NSTextAlignmentCenter;
    bottomLbl.font = kSmallFont;
    [scrollPane addSubview:bottomLbl];
    
    originY += lblHeight + kEPadding * 2;
    bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(originX, originY, blockWidth, blockHeight);
    [bottomBtn setBackgroundImage:IMAGE_BY_NAMED(@"add") forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:bottomBtn];
    
    originX = kEPadding * 3;
    originY += blockHeight + kEPadding * 8;
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(originX, originY, kFrameWidth - originX * 2, 45);
    submitBtn.backgroundColor = kThemeColor;
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kBigFont;
    submitBtn.layer.cornerRadius = 5.f;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:submitBtn];
    
    scrollPane.contentSize = CGSizeMake(scrollPane.bounds.size.width, originY + 45 + 70);
    
    // 身份证已经上传
    NSString *frontUrl = [[kUserDefaults objectForKey:kCertificateFront] realString];
    NSString *backUrl = [[kUserDefaults objectForKey:kCertificateBack] realString];
    if (frontUrl && backUrl) {
        topLbl.text = @"身份证正面";
        bottomLbl.text = @"身份证反面";
        topBtn.userInteractionEnabled = NO;
        bottomBtn.userInteractionEnabled = NO;
        [topBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:frontUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                
            }
        }];
        [bottomBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:backUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                
            }
        }];
    }
}

- (void)configNavigationBar {
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 24, 24);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

- (void)topBtnAction {
    // 身份证已经上传
    NSString *frontUrl = [[kUserDefaults objectForKey:kCertificateFront] realString];
    NSString *backUrl = [[kUserDefaults objectForKey:kCertificateBack] realString];
    if (frontUrl && backUrl) {
        return;
    }
    
    isTopImage = YES;
    [self showImagePicker];
}

- (void)bottomBtnAction {
    // 身份证已经上传
    NSString *frontUrl = [[kUserDefaults objectForKey:kCertificateFront] realString];
    NSString *backUrl = [[kUserDefaults objectForKey:kCertificateBack] realString];
    if (frontUrl && backUrl) {
        return;
    }
    
    isTopImage = NO;
    [self showImagePicker];
}

- (void)showImagePicker {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传身份证" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *takePhotosAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            EImagePickerController *imagePicker = [[EImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [strongSelf presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *fromLibrariesAction = [UIAlertAction actionWithTitle:@"从手机相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            EImagePickerController *imagePicker = [[EImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            imagePicker.mediaTypes = mediaTypes;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [strongSelf presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:takePhotosAction];
    [alertController addAction:fromLibrariesAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)submitBtnAction {
    if (!selectedTopImage) {
        [self showTips:@"请上传身份证正面" time:1 completion:nil];
    } else if (!selectedBottomImage) {
        [self showTips:@"请上传身份证反面" time:1 completion:nil];
    } else {
        [self startLoading:YES];
        NSInteger userId = [kUserDefaults integerForKey:kUserId];
        NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
        NSData *imageData_top = UIImageJPEGRepresentation(selectedTopImage,0.5);
        NSString *dataStr_top = [imageData_top base64EncodedStringWithOptions:0];
        dataStr_top = [@"data:image/jpeg;base64," stringByAppendingString:dataStr_top];
        WEAK
        [[EApiClient sharedClient] uploadPicture:userId imageType:@"certificate_image_front" imageData:dataStr_top accessToken:accessToken completion:^(id responseObject, NSError *error) {
            STRONG
            if (responseObject) {
                NSData *imageData_bottom = UIImageJPEGRepresentation(selectedTopImage,0.5);
                NSString *dataStr_bottom = [imageData_bottom base64EncodedStringWithOptions:0];
                dataStr_bottom = [@"data:image/jpeg;base64," stringByAppendingString:dataStr_bottom];
                [[EApiClient sharedClient] uploadPicture:userId imageType:@"certificate_image_back" imageData:dataStr_bottom accessToken:accessToken completion:^(id responseObject, NSError *error) {
                    STRONG
                    [strongSelf startLoading:NO];
                    if (responseObject) {
                        [strongSelf showTips:@"身份证上传成功" time:1 completion:nil];
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    } else {
                        [strongSelf showTips:@"身份证反面上传失败" time:1 completion:nil];
                    }
                }];
            } else {
                [strongSelf startLoading:NO];
                [strongSelf showTips:@"身份证正面上传失败" time:1 completion:nil];
            }
        }];
    }
}

- (void)resetImage {
    if (isTopImage) {
        [topBtn setBackgroundImage:selectedTopImage forState:UIControlStateNormal];
    } else {
        [bottomBtn setBackgroundImage:selectedBottomImage forState:UIControlStateNormal];
    }
}

#pragma mark - UINavigationControllerDelegate  以下两个方法可以统一状态条颜色，避免点击相册到选择照片页面的时候状态条文字颜色变黑不统一!!!

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (isTopImage) {
        selectedTopImage = originImage;
        DLog(@"正面图片大小 : %lu KB",(unsigned long)UIImageJPEGRepresentation(selectedTopImage,0.5).length / 1024);
    } else {
        selectedBottomImage = originImage;
        DLog(@"反面图片大小 : %lu KB",(unsigned long)UIImageJPEGRepresentation(selectedBottomImage,0.5).length / 1024);
    }
    [self resetImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
