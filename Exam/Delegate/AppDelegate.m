//
//  AppDelegate.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "AppDelegate.h"
#import "EMainTypeController.h"
#import "ERegisterController.h"
#import "ELoginController.h"
#import <UMSocialCore/UMSocialCore.h>

#define DB_NAME @"exam"
#define USHARE_DEMO_APPKEY @"5861e5daf5ade41326001eab"

@interface AppDelegate ()

@end

@implementation AppDelegate


/**
 拷贝数据库文件到黑盒
 */
- (void)copyDBFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    // 往应用程序路径中添加数据库文件名称，把它们拼接起来
    NSString *dbFilePath = [path stringByAppendingPathComponent:@"exam.db"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbFilePath];
    // 如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist) {
        // 获取工程里数据库的路径
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:@"exam"
                                  ofType:@"db"];
        // 通过NSFileManager对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
        DLog(@"cp = %d",cp);
        DLog(@"backupDbPath : %@",backupDbPath);
    }
}

- (void)switchToLoginRegisterController {
    ELoginController *loginController = [[ELoginController alloc] init];
    self.nav = [[ENavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = self.nav;
}

- (void)switchToNavigationController {
    EMainTypeController *mainType = [[EMainTypeController alloc] init];
    self.nav = [[ENavigationController alloc] initWithRootViewController:mainType];
    self.window.rootViewController = self.nav;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    DLog(@"document路径 : %@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0]);
    
    // 清空NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 增加标识，用于判断是否是第一次启动应用...
    if (![kUserDefaults boolForKey:@"everLaunched"]) {
        [kUserDefaults setBool:YES forKey:@"everLaunched"];
        [kUserDefaults synchronize];
        [kUserDefaults setBool:YES forKey:@"firstLaunch"];
        [kUserDefaults synchronize];
    } else {
        [kUserDefaults setBool:NO forKey:@"firstLaunch"];
        [kUserDefaults synchronize];
    }
    // 第一次启动
    if ([kUserDefaults boolForKey:@"firstLaunch"]) {
        [self copyDBFile];
    } else {
        
    }
    
    BOOL isLogin = [kUserDefaults boolForKey:kIsLogin];
    if (isLogin) {
        [self switchToNavigationController];
    } else {
        [self switchToLoginRegisterController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)confitUShareSettings {
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
