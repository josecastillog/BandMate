//
//  AppDelegate.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 6/30/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        configuration.applicationId = @"a0vCed2RCYR7A6X8SW44TekjIuSGIV8WuOAioAjR";
        configuration.clientKey = @"jcFJOqHwCPxnrVDv92BL0R6XtYPkraNcI5nVFglm";
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
