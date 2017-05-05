//
//  AppDelegate.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "AppDelegate.h"
#import "EWelcomeController.h"
#import "EMainTypeController.h"
#import "ERegisterController.h"
#import "ELoginController.h"

#define DB_NAME @"exam"

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

- (void)switchToWelcomeController {
    EWelcomeController *welcome = [[EWelcomeController alloc] init];
    self.window.rootViewController = welcome;
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
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self switchToWelcomeController];
    
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
    
    [self.window makeKeyAndVisible];
    
    return YES;
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
