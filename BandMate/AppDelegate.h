//
//  AppDelegate.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 6/30/22.
//

#import <UIKit/UIKit.h>
#import "AppAuth.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;
@end
