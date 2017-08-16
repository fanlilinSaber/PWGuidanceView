//
//  AppDelegate.m
//  PWGuidanceView
//
//  Created by 范李林 on 2017/8/14.
//  Copyright © 2017年 FLL. All rights reserved.
//

#import "AppDelegate.h"
#import "PWIntroViewController.h"
#import "PWIntroPage.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray *images = @[@"http://img.taopic.com/uploads/allimg/130517/240392-13051H0530958.jpg",
                        @"http://www.pp3.cn/uploads/201607/20160712011.jpg",
                        @"http://img06.tooopen.com/images/20160712/tooopen_sy_170083325566.jpg",
                        @"http://pic44.nipic.com/20140721/11624852_001107119409_2.jpg"];
    NSArray *videos = @[@"1.扫描图像", @"2.扫描模型", @"3.扫描图码"];
    NSMutableArray *intros = [NSMutableArray new];
    for (int i = 0; i < images.count; i ++) {
        PWIntroPage *introPage = [PWIntroPage new];
        introPage.type = IntroPhoto;
        introPage.url = [NSURL URLWithString:images[i]];
        if (i == 1) {
            introPage.type = IntroVideo;
            introPage.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/14525705791193.mp4"];
        }
        else if (i == 2){
            introPage.type = IntroVideo;
            introPage.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1.扫描图像" ofType:@"mp4"]];
        }
        else if (i == 3){
            introPage.type = IntroGif;
            introPage.data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"animate" ofType:@"gif"]];
        }

//        introPage.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:videos[i] ofType:@"mp4"]];
        
        [intros addObject:introPage];
    }
    
    PWIntroViewController *rootVc = [[PWIntroViewController alloc] initWithIntros:intros];
    [self.window setRootViewController:rootVc];
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
