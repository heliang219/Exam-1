//
//  ESettingController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ESettingController.h"
#import "EUploadIDCardController.h"
#import "EAboutController.h"
#import <UShareUI/UShareUI.h>
#import "EUpdateController.h"
#import "UINavigationBar+Awesome.h"
#import "EImagePickerController.h"
#import "UIButton+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Additions.h"
#import "EApiClient.h"
#import "EUtils.h"
#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"
#import "EMySubjectsController.h"
#import "EDBHelper.h"

#define headerHeight 165.f * kFrameHeight / 667.f
#define avatorWidth 68.f * kFrameHeight / 667.f

static NSString* const UMS_Title = @"【友盟+】社会化组件U-Share";
static NSString* const UMS_Web_Desc = @"W欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";
static NSString* const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
static NSString* const UMS_WebLink = @"http://mobile.umeng.com/social";

@interface ESettingController ()<UITableViewDelegate,UITableViewDataSource,UMSocialShareMenuViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *_tableView;
    UIButton *_avatorBtn;
    UIImage *_selectedHeaderImg;
}

@end

@implementation ESettingController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self initHeader];
    [self initTable];
    
    // 设置用户自定义的分享平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               ]];
    // 设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

- (void)configNavigationBar {
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 24, 24);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"close") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"close") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUserInfo];
}

/**
 初始化顶部logo视图
 */
- (void)initHeader {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, headerHeight)];
    headView.backgroundColor = kThemeColor;
    [self.view addSubview:headView];
    
    _avatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatorBtn.frame = CGRectMake(153.f * kFrameWidth / 375.f, kNavigationBarHeight + kEPadding, avatorWidth, avatorWidth);
    UIImage *localAvator = [EUtils getLocalAvator] ?: IMAGE_BY_NAMED(@"setting_avator");
    [_avatorBtn setBackgroundImage:localAvator forState:UIControlStateNormal];
    [_avatorBtn setBackgroundImage:localAvator forState:UIControlStateHighlighted];
    _avatorBtn.layer.cornerRadius = avatorWidth / 2.f;
    _avatorBtn.layer.masksToBounds = YES;
    [_avatorBtn addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_avatorBtn];
}

- (void)initTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerHeight, kFrameWidth, kFrameHeight - headerHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setTableFooterView:[self buildTableFooter]];
    [self.view addSubview:_tableView];
}

- (UIView *)buildTableFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 100)];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kEPadding * 3, kEPadding * 3, footer.bounds.size.width - kEPadding * 6, 45.f);
    [shareBtn setTitle:@"软件分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.backgroundColor = kThemeColor;
    shareBtn.titleLabel.font = kBigFont;
    shareBtn.layer.cornerRadius = 5.f;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:shareBtn];
    
    return footer;
}

- (void)shareBtnAction {
    DLog(@"软件分享");
    // 显示分享面板
    __weak typeof (self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        // 根据获取的platformType确定所选平台进行下一步操作
        [strongSelf shareWebPageToPlatformType:platformType];
    }];
}

// 网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    // 创建网页内容对象
    NSString *thumbURL =  UMS_THUMB_IMAGE;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:UMS_Title descr:UMS_Web_Desc thumImage:thumbURL];
    // 设置网页地址
    shareObject.webpageUrl = UMS_WebLink;
    
    // 分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    // 调用分享接口
    WEAK
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        STRONG
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        } else {
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                // 分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                // 第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            } else {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [strongSelf alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    } else {
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        } else {
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"使用者姓名";
            cell.detailTextLabel.text = [kUserDefaults objectForKey:kName] ?: @"匿名用户";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"身份证上传";
            NSString *frontUrl = [[kUserDefaults objectForKey:kCertificateFront] realString];
            NSString *backUrl = [[kUserDefaults objectForKey:kCertificateBack] realString];
            if (frontUrl && backUrl) {
                cell.detailTextLabel.text = @"已上传";
            } else {
                cell.detailTextLabel.text = @"未上传";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"我的题库";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"剩余练习次数";
            cell.detailTextLabel.text = [kUserDefaults integerForKey:kTrailCount] ? [NSString stringWithFormat:@"%@次",@([kUserDefaults integerForKey:kTrailCount])] : @"0次";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于腾飞安培";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"题库更新";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) { // 身份证上传
            EUploadIDCardController *uploadIDCardController = [[EUploadIDCardController alloc] init];
            [self.navigationController pushToController:uploadIDCardController animated:YES];
        } else if (indexPath.row == 2) { // 我的题库
            NSMutableArray *subjects = [kUserDefaults objectForKey:kSelectedNumbers];
            NSMutableArray *arr = [NSMutableArray array];
            if (subjects && subjects.count > 0) {
                for (int i = 0; i < subjects.count; i ++) {
                    NSInteger subjectId = [subjects[i] integerValue];
                    ESubject *subject = [[EDBHelper defaultHelper] querySubjectById:subjectId];
                    [arr addObject:subject];
                }
            }
            EMySubjectsController *controller = [[EMySubjectsController alloc] initWithContentArray:arr];
            [self.navigationController pushToController:controller animated:YES];
        } else {
            
        }
    } else {
        if (indexPath.row == 0) {
            EAboutController *aboutController = [[EAboutController alloc] init];
            [self.navigationController pushToController:aboutController animated:YES];
        } else {
            EUpdateController *updateController = [[EUpdateController alloc] init];
            [self.navigationController pushToController:updateController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UMSocialShareMenuViewDelegate

- (void)UMSocialShareMenuViewDidAppear {
    
}

- (void)UMSocialShareMenuViewDidDisappear {
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _selectedHeaderImg = [originImage resizeToSize:_avatorBtn.frame.size];
    NSData *imageData = UIImageJPEGRepresentation(originImage,0.5);
    NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
    dataStr = [@"data:image/jpeg;base64," stringByAppendingString:dataStr];
    DLog(@"头像图片大小 : %lu KB",(unsigned long)imageData.length / 1024);
    [self resetImage];
    NSInteger userId = [kUserDefaults integerForKey:kUserId];
    NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
    WEAK
    [[EApiClient sharedClient] uploadPicture:userId imageType:@"avatar" imageData:dataStr accessToken:accessToken completion:^(id responseObject, NSError *error) {
        STRONG
        if (responseObject) {
            [strongSelf showTips:@"头像上传成功" time:1 completion:nil];
            [EUtils saveLocalAvator:originImage];
        } else {
            [strongSelf showTips:@"头像上传失败" time:1 completion:nil];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Other Methods

/**
 获取用户信息
 */
- (void)getUserInfo {
    NSInteger user_Id = [kUserDefaults integerForKey:kUserId];
    NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
    WEAK
    [[EApiClient sharedClient] getUserInfo:user_Id accessToken:accessToken completion:^(id responseObject, NSError *error) {
        STRONG
        if (responseObject) {
            // 保存用户信息
            NSInteger userId = [responseObject integerValueForKey:@"id" defaultValue:-1];
            NSString *accessToken = [responseObject stringValueForKey:@"access_token" defaultValue:nil];
            NSString *name = [responseObject stringValueForKey:@"name" defaultValue:nil];
            NSString *phone = [responseObject stringValueForKey:@"phone" defaultValue:nil];
            NSInteger trailCount = [responseObject integerValueForKey:@"trail_count" defaultValue:0];
            NSDictionary *avatorDic = [responseObject dictionaryValueForKey:@"avatar" defaultValue:nil];
            if (avatorDic) {
                NSString *avatorUrl = [avatorDic stringValueForKey:@"url" defaultValue:nil];
                avatorUrl = [[EApiClient sharedClient].baseUrl stringByAppendingString:avatorUrl];
                [kUserDefaults setObject:avatorUrl forKey:kAvatorUrl];
                [kUserDefaults synchronize];
                [strongSelf->_avatorBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:avatorUrl] forState:UIControlStateNormal placeholderImage:IMAGE_BY_NAMED(@"setting_avator") options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    // 保存图片到本地
                    if (image) {
                        [EUtils saveLocalAvator:image];
                    } else {
                        [EUtils saveLocalAvator:IMAGE_BY_NAMED(@"setting_avator")];
                    }
                }];
            }
            NSDictionary *certificate_frontDic = [responseObject dictionaryValueForKey:@"certificate_image_front" defaultValue:nil];
            if (certificate_frontDic) {
                NSString *frontUrl = [NSString stringWithFormat:@"%@%@",[EApiClient sharedClient].baseURL,[certificate_frontDic stringValueForKey:@"url" defaultValue:nil]];
                [kUserDefaults setObject:frontUrl forKey:kCertificateFront];
                [kUserDefaults synchronize];
            }
            NSDictionary *certificate_backDic = [responseObject dictionaryValueForKey:@"certificate_image_back" defaultValue:nil];
            if (certificate_backDic) {
                NSString *backUrl = [NSString stringWithFormat:@"%@%@",[EApiClient sharedClient].baseURL,[certificate_backDic stringValueForKey:@"url" defaultValue:nil]];
                [kUserDefaults setObject:backUrl forKey:kCertificateBack];
                [kUserDefaults synchronize];
            }
            // 保存用户信息
            [kUserDefaults setBool:YES forKey:kIsLogin];
            [kUserDefaults synchronize];
            [kUserDefaults setInteger:userId forKey:kUserId];
            [kUserDefaults synchronize];
            [kUserDefaults setObject:accessToken forKey:kAccess_Token];
            [kUserDefaults synchronize];
            [kUserDefaults setObject:name forKey:kName];
            [kUserDefaults synchronize];
            [kUserDefaults setObject:phone forKey:kPhone];
            [kUserDefaults synchronize];
            [kUserDefaults setInteger:trailCount forKey:kTrailCount];
            [kUserDefaults synchronize];
            NSArray *subjectsArr = [responseObject arrayValueForKey:@"selected_subjects" defaultValue:nil];
            if (subjectsArr && subjectsArr.count > 0) {
                [kUserDefaults setObject:subjectsArr forKey:kSelectedNumbers];
                [kUserDefaults synchronize];
            } else {
                [kUserDefaults setObject:nil forKey:kSelectedNumbers];
                [kUserDefaults synchronize];
            }
            // 激活状态
            NSString *activateStatus = [responseObject stringValueForKey:@"activation_status" defaultValue:@""];
            if ([activateStatus isEqualToString:@"trail"]) { // 未激活
                DLog(@"账号未激活");
            } else { // 已激活
                DLog(@"账号已激活");
            }
            [strongSelf->_tableView reloadData];
        }
    }];
}

- (void)resetImage {
    [_avatorBtn setBackgroundImage:_selectedHeaderImg forState:UIControlStateNormal];
    [_avatorBtn setBackgroundImage:_selectedHeaderImg forState:UIControlStateHighlighted];
}

- (void)showImagePicker {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择更换头像的方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK
    UIAlertAction *takePhotosAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            EImagePickerController *imagePicker = [[EImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [strongSelf presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *fromLibrariesAction = [UIAlertAction actionWithTitle:@"从手机相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
