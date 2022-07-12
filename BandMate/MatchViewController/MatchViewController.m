//
//  MatchViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/11/22.
//

#import "MatchViewController.h"
#import "AppAuth.h"
#import "AppDelegate.h"

// Spotify OAuth 2.0 configuration
static NSString *kClientID;
static NSString *const kIssuer = @"https://accounts.spotify.com/";
static NSString *const kRedirectStringURI = @"app.bandmate:/callback";
static NSString *const kAppAuthBandMateStateKey = @"authState";
static NSString *const scope = @"user-top-read";

@interface MatchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UIButton *apiCallButton;
@property(strong, nonatomic, nullable) OIDAuthState *authState;
@end

@implementation MatchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setup];

}

- (void)setup {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    kClientID = [dict objectForKey: @"client_ID"];
    
    [self loadState];
    
    if (self.authState) {
        self.connectButton.enabled = NO;
    } else {
        self.disconnectButton.enabled = NO;
        self.apiCallButton.enabled = NO;
    }
    
}

// Temporary buttons for testing
- (IBAction)didTapConnect:(id)sender {
    [self performOAuth];
}

- (IBAction)didTapDisconnect:(id)sender {
    [self deleteState];
}

- (IBAction)didTapApiCall:(id)sender {
    [self getTopArtists];
}

// Performs Spotify OAuth 2.0
- (void)performOAuth {
    
    NSURL *issuer = [NSURL URLWithString:kIssuer];
    NSURL *kRedirectURI = [NSURL URLWithString:kRedirectStringURI];
    
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer completion:^(OIDServiceConfiguration * _Nullable configuration, NSError * _Nullable error) {
        
        if (!configuration) {
            NSLog(@"Error retrieving discovery document: %@", [error localizedDescription]);
            return;
        }
        
        // Build authentication request
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientID
                                                        scopes:@[scope]
                                                   redirectURL:kRedirectURI
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        
        // Makes authentication request
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request presentingViewController:self callback:^(OIDAuthState * _Nullable authState, NSError * _Nullable error) {
            if (authState) {
                NSLog(@"Got authorization tokes. Access tokes: %@", authState.lastTokenResponse.accessToken);
                [self setAuthState:authState];
                [self saveState];
                self.connectButton.enabled = NO;
                self.disconnectButton.enabled = YES;
                self.apiCallButton.enabled = YES;
            } else {
                NSLog(@"Authorization error: %@", [error localizedDescription]);
                [self setAuthState:nil];
            }
        }];
        
    }];
    
}

// Stores OIDAuthState state in NSUserdefaults
- (void)saveState {
  NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"bandmate.authState"];
  NSData *archivedAuthState = [NSKeyedArchiver archivedDataWithRootObject:_authState];
  [userDefaults setObject:archivedAuthState
                   forKey:kAppAuthBandMateStateKey];
  [userDefaults synchronize];
}

// Loads OIDAuthState from NSUSerDefaults
- (void)loadState {
  NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"bandmate.authState"];
  NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthBandMateStateKey];
  OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
  [self setAuthState:authState];
}

// Deletes OIDAuthState when logout of Spotify
-(void)deleteState {
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"bandmate.authState"];
    [userDefaults removeObjectForKey:kAppAuthBandMateStateKey];
    [userDefaults synchronize];
    [self setAuthState:nil];
    self.connectButton.enabled = YES;
    self.disconnectButton.enabled = NO;
    self.apiCallButton.enabled = NO;
}

// API call always with fresh OAuth 2.0 tokens
- (void)getTopArtists {

    [self.authState performActionWithFreshTokens:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            NSString *token = @"Bearer ";
            NSString *authHeader = [token stringByAppendingString:accessToken];
            
            [request setURL:[NSURL URLWithString:@"https://api.spotify.com/v1/me/top/artists"]];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
                NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                NSLog(@"Request reply: %@", requestReply);

            }] resume];
        }
        
    }];
    
}

@end
