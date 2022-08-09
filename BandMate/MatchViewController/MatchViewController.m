//
//  MatchViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/11/22.
//

#import "MatchViewController.h"
#import "AppDelegate.h"
#import "Artist.h"
#import "AppAuth.h"
#import "Parse/Parse.h"
#import "Match.h"
#import "MatchTableViewCell.h"
#import "MatchDetailsViewController.h"

// Spotify OAuth 2.0 configuration
static NSString *kClientID;
static NSString *const kIssuer = @"https://accounts.spotify.com/";
static NSString *const kRedirectStringURI = @"app.bandmate:/callback";
static NSString *const kAppAuthBandMateStateKey = @"authState";
static NSString *const kScope = @"user-top-read";
// Spotify Api Request
static NSString* url = @"https://api.spotify.com/v1/me/top/artists?time_range=long_term&limit=20";
// Info.plist properties
static NSString *const kPathForResource = @"Keys";
static NSString *const kType = @"plist";
static NSString *const kClientIdKey = @"client_ID_spotify";
// Spotify button properties
static double const kPositionX = 0;
static double const kPositionY = 0;
static double const kWidth = 200;
static double const kHeight = 90;
static double const kCornerRadius = 20;
static NSString *const kButtonTitle = @"Connect Spotify and start matching!";
// Table view settings
static NSString* kCellName = @"MatchCell";
// User table keys
static NSString* kUserMatchesRelation = @"Matches";
static NSString* kFavoriteGenres = @"fav_genres";
static NSString* kFavoriteArtists = @"fav_artists";
static NSString* kObjectId = @"objectId";
static NSString* kUserRelationCurrentBands = @"currentBands";
// Match table keys
static NSString* kMatchNumberOfMembers = @"numberOfMembers";
// Query parameters
static NSNumber* kMaxNumberOfMembers = @4;
// NSUserDefaults
static NSString* kSuiteName = @"bandmate.authState";
// Alerts
static NSString *const kActionTitle = @"Ok";
static NSString *const kSpotifyAuthAlert = @"Spotify Authentication could not be completed.";
static NSString *const kSpotifyFetchAlert = @"Error while retrieving data from Spotify";
static NSString *const kAcceptTitle = @"Match accepted!";
static NSString *const kAcceptMessage = @"Match accepted!";
static NSString *const kDeclineTitle = @"Match declined";
static NSString *const kDeclineMessage = @"Your match has been declined";
static NSString *const kEmptyString = @"";
static CGFloat const kAnimationTimeInterval = 2.5;

@interface MatchViewController () <UITableViewDelegate, UITableViewDataSource, MatchDetailsViewControllerDelegate>
@property (strong, nonatomic) NSArray *arrayOfArtists;
@property (strong, nonatomic) NSMutableArray *arrayOfMatches;
@property (strong, nonatomic) UIButton *spotifyButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic, nullable) OIDAuthState *authState;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MatchViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:kPathForResource ofType:kType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    kClientID = [dict objectForKey:kClientIdKey];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryUserMatches) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self setMatchingScreen];
}

- (void)setMatchingScreen {
    [self loadState];
    if (_authState) {
        [self queryUserMatches];
    } else {
        [self setConnectSpotifyButton];
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMatches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellName forIndexPath:indexPath];
    Match *match = self.arrayOfMatches[indexPath.row];
    [cell setCell:match];
    return cell;
}

#pragma mark - Network

- (void)queryUserMatches {
    PFRelation *relationBands = [PFUser.currentUser relationForKey:kUserRelationCurrentBands];
    PFQuery *queryBands = [relationBands query];
    PFRelation *relation = [PFUser.currentUser relationForKey:kUserMatchesRelation];
    PFQuery *query = [relation query];
    [query whereKey:kMatchNumberOfMembers equalTo:kMaxNumberOfMembers];
    [query whereKey:kObjectId doesNotMatchKey:kObjectId inQuery:queryBands];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [self alert:error.localizedDescription];
        } else {
            self.arrayOfMatches = [NSMutableArray arrayWithArray:objects];
            self.arrayOfMatches.count > 0 ? self.tableView.reloadData: [Match startMatching];
            [self.refreshControl endRefreshing];
        }
    }];
}

// Performs Spotify OAuth 2.0
- (void)performOAuth {
    
    NSURL *issuer = [NSURL URLWithString:kIssuer];
    NSURL *kRedirectURI = [NSURL URLWithString:kRedirectStringURI];
    
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer completion:^(OIDServiceConfiguration * _Nullable configuration, NSError * _Nullable error) {
        
        if (!configuration) {
            [self alert:kSpotifyAuthAlert];
            return;
        }
        
        // Build authentication request
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientID
                                                        scopes:@[kScope]
                                                   redirectURL:kRedirectURI
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        
        // Makes authentication request
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request presentingViewController:self callback:^(OIDAuthState * _Nullable authState, NSError * _Nullable error) {
            if (authState) {
                [self setAuthState:authState];
                [self saveState];
                [self getTopArtists];
            } else {
                [self alert:kSpotifyAuthAlert];
                [self setAuthState:nil];
            }
        }];
        
    }];
    
}

// Stores OIDAuthState state in NSUserdefaults
- (void)saveState {
  NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSuiteName];
  NSData *archivedAuthState = [NSKeyedArchiver archivedDataWithRootObject:_authState];
  [userDefaults setObject:archivedAuthState
                   forKey:kAppAuthBandMateStateKey];
  [userDefaults synchronize];
}

// Loads OIDAuthState from NSUSerDefaults
- (void)loadState {
  NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSuiteName];
  NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthBandMateStateKey];
  OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
  [self setAuthState:authState];
}

// Deletes OIDAuthState when logout of Spotify
-(void)deleteState {
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSuiteName];
    [userDefaults removeObjectForKey:kAppAuthBandMateStateKey];
    [userDefaults synchronize];
    [self setAuthState:nil];
}

// API call always with fresh OAuth 2.0 tokens
- (void)getTopArtists {

    [self.authState performActionWithFreshTokens:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
        
        if (error != nil) {
            [self alert:error.localizedDescription];
        } else {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            NSString *token = @"Bearer ";
            NSString *authHeader = [token stringByAppendingString:accessToken];
            
            [request setURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    [self alert:kSpotifyFetchAlert];
                    return;
                }
                
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSArray *arrayOfDictionaries = dataDictionary[@"items"];
                
                // Creates array of Artist object
                self.arrayOfArtists = [Artist artistsWithArray:arrayOfDictionaries];
                
                // Saves artists to DB
                [PFObject saveAllInBackground:self.arrayOfArtists block:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error || [error code] == 137) {
                        [Match startMatching];
                        [self.spotifyButton removeFromSuperview];
                        [self setMatchingScreen];
                    } else {
                        [self alert:error.localizedDescription];
                    }
                }];
                
                NSArray *arrayOfGenres = [Artist userGenresWithArray:self.arrayOfArtists];
                NSArray *arrayOfArtistID = [Artist userArtistIDsWithArray:self.arrayOfArtists];
                
                [PFUser.currentUser setObject:arrayOfGenres forKey:kFavoriteGenres];
                [PFUser.currentUser setObject:arrayOfArtistID forKey:kFavoriteArtists];
                
                // Saves fav_genres and fav_artists to user in DB
                [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                    if (error) {
                        [self alert:error.localizedDescription];
                    }
                    
                }];

            }] resume];
        }
        
    }];
    
}

#pragma mark - Alerts

- (void)alert:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:message
                                   message:kEmptyString
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kActionTitle style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAcceptDeclineAlert:(NSString*)title :(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationTimeInterval repeats:NO block:^(NSTimer *_Nonnull timer) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Helper Functions

- (void)didTapAcceptButton:(Match *)match {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [generator impactOccurred];
    [self showAcceptDeclineAlert:kAcceptTitle :kAcceptMessage];
    [self.arrayOfMatches removeObject:match];
    [self.tableView reloadData];
}

- (void)didTapDeclineButton:(Match *)match {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
    [self showAcceptDeclineAlert:kDeclineTitle :kDeclineMessage];
    [self.arrayOfMatches removeObject:match];
    [self.tableView reloadData];
}

- (void)setConnectSpotifyButton {
    self.spotifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.spotifyButton addTarget:self action:@selector(performOAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.spotifyButton setTitle:@"Connect Spotify and start matching!" forState:UIControlStateNormal];
    self.spotifyButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.spotifyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.spotifyButton.backgroundColor = [UIColor systemGreenColor];
    self.spotifyButton.frame = CGRectMake(kPositionX, kPositionY, kWidth, kHeight);
    self.spotifyButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.spotifyButton.layer.cornerRadius = kCornerRadius;
    self.spotifyButton.clipsToBounds = YES;
    [self.view addSubview:self.spotifyButton];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MatchDetailsViewController *detailsController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Match *match = self.arrayOfMatches[indexPath.row];
    detailsController.match = match;
    detailsController.delegate = self;
}

@end
