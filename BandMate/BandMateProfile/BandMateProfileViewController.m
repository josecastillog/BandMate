//
//  BandMateProfileViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 8/4/22.
//

#import "BandMateProfileViewController.h"
#import "Artist.h"
#import "ProfileTableCell.h"

// User table keys
static NSString *const kUserInstrumentType = @"instrumentType";
static NSString *const kUserName = @"name";
static NSString *const kUserUsername = @"username";
static NSString *const kUserProfileImage = @"profileImage";
static NSString *const kUserFavArtists = @"fav_artists";
// Artist table keys
static NSString *const kArtistArtistId = @"artistID";
// Alerts
static NSString *const kActionTitle = @"Ok";
static NSString *const kEmptyString = @"";
// Table view
static NSString *const kCellIdentifier = @"ProfileCell";
// Styling
static CGFloat const kBorderWidth = 0.1;
static NSString *const kStringFormat = @"@%@";

@interface BandMateProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet PFImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instrumentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSArray *arrayOfArtists;
@end

@implementation BandMateProfileViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self queryTopArtists];
    [self setupProfile];
}

- (void)setupProfile {
    // Labels
    self.nameLabel.text = [self.user objectForKey:kUserName];
    self.usernameLabel.text = [NSString stringWithFormat:kStringFormat, [self.user objectForKey:kUserUsername]];
    self.instrumentLabel.text = [self.user objectForKey:kUserInstrumentType];
    // Profile image
    self.imgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.imgView.layer.cornerRadius = self.imgView.frame.size.height/2;
    self.imgView.layer.borderWidth = kBorderWidth;
    self.imgView.clipsToBounds = YES;
    [self setProfileImage];
}

- (void)setProfileImage {
    if (self.user[kUserProfileImage]) {
        self.imgView.file = self.user[kUserProfileImage];
        [self.imgView loadInBackground];
    }
}

#pragma mark - Network

- (void)queryTopArtists {
    PFQuery *query = [Artist query];
    [query whereKey:kArtistArtistId containedIn: [self.user objectForKey: kUserFavArtists]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
             [self alert:error.localizedDescription];
        } else {
            self.arrayOfArtists = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.arrayOfArtists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                 forIndexPath:indexPath];
    Artist *artist = self.arrayOfArtists[indexPath.row];
    [cell setArtist:artist];
    return cell;
}

#pragma mark - Alert

- (void)alert:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:message
                                   message:kEmptyString
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kActionTitle style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
