//
//  MatchDetailsViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import "MatchDetailsViewController.h"
#import "DetailsTableViewCell.h"
#import "Artist.h"
#import "Conversation.h"
#import "UIImageView+AFNetworking.h"

// User table keys
static NSString *const kUserName = @"name";
static NSString *const kUserProfileImage = @"profileImage";
static NSString *const kObjectId = @"objectId";
static NSString *const kUserInstrumentType = @"instrumentType";
static NSString *const kUserUsername = @"username";
static NSString *const kUserRelationBands = @"currentBands";
static NSString *const kUserRelationMatch = @"Matches";
static NSString *const kUserRelationConversation = @"conversations";
// Match table keys
static NSString *const kMatchMembersRelation = @"members";
static NSString *const kMatchRelationAccepted = @"membersAccepted";
// Artist table keys
static NSString *const kArtistArtistId = @"artistID";
// Conversation table keys
static NSString *const kConversationMatch = @"match";
// Buttons settings
static int const kButtonCornerRadius = 20;
// Artist image settings
static int const kImageCornerRadiues = 10;
static NSString *const kDictionaryKey = @"url";
// Table view settings
static NSString *const kCellName = @"ProfileCell";
// Alerts
static NSString *const kActionTitle = @"Ok";
static NSString *const kEmptyString = @"";

@interface MatchDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIImageView *artistImgView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) NSArray *arrayOfUsers;
@end

@implementation MatchDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self styleButtons];
    [self queryArtist];
    [self queryMembers];
}

- (void)styleButtons {
    self.acceptButton.layer.cornerRadius = kButtonCornerRadius;
    self.acceptButton.clipsToBounds = YES;
    self.declineButton.layer.cornerRadius = kButtonCornerRadius;
    self.declineButton.clipsToBounds = YES;
}

- (void)queryArtist {
    PFQuery *query = [Artist query];
    [query whereKey:kArtistArtistId equalTo:self.match.artistID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [self alert:error.localizedDescription];
        } else {
            [self setArtist:[objects firstObject]];
        }
    }];
}

- (void)queryMembers {
    
    PFRelation *relation = [self.match relationForKey:kMatchMembersRelation];
    PFQuery *queryMembers = [relation query];
    [queryMembers includeKey:kUserName];
    [queryMembers includeKey:kUserProfileImage];
    [queryMembers includeKey:kUserInstrumentType];
    [queryMembers includeKey:kUserUsername];
    [queryMembers whereKey:kObjectId notEqualTo:PFUser.currentUser.objectId];
    
    [queryMembers findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [self alert:error.localizedDescription];
        } else {
            self.arrayOfUsers = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)setArtist:(Artist*)artist {
    self.artistLabel.text = artist.name;
    NSString *displayGenres = [NSString string];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    self.followersLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:artist.followers]];
    
    for (NSString *genre in artist.genres) {
        if ([genre isEqualToString:[artist.genres firstObject]]) {
            displayGenres = genre;
        }
        displayGenres = [NSString stringWithFormat:@"%@, %@", displayGenres, genre];
    }
    self.genreLabel.text = displayGenres;
    
    self.artistImgView.layer.cornerRadius = kImageCornerRadiues;
    NSDictionary *image = [artist.images firstObject];
    NSURL *posterURL = [NSURL URLWithString:image[kDictionaryKey]];
    [self.artistImgView setImageWithURL:posterURL];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapAccept:(id)sender {
    PFRelation *userRelation = [PFUser.currentUser relationForKey:kUserRelationBands];
    [userRelation addObject:self.match];
    [PFUser.currentUser saveInBackground];
    PFRelation *matchRelation = [self.match relationForKey:kMatchRelationAccepted];
    [matchRelation addObject:PFUser.currentUser];
    [self.match saveInBackground];
    PFQuery *query = [Conversation query];
    [query whereKey:kConversationMatch equalTo: self.match];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [self alert:error.localizedDescription];
        } else {
            Conversation *conversation = [objects firstObject];
            objects.count > 0 ? [self didTapAcceptHelper:conversation] : [self didTapAcceptHelper:nil];
        }
    }];
}

- (void)didTapAcceptHelper:(Conversation*)conversation {
    if (conversation) {
        [conversation addParticipant:PFUser.currentUser];
        [conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:error.localizedDescription];
            } else {
                PFRelation *userRelation = [PFUser.currentUser relationForKey:kUserRelationConversation];
                [userRelation addObject:conversation];
                [PFUser.currentUser saveInBackground];
            }
        }];
    } else {
        Conversation *conversation = [Conversation initWithMatch:self.match];
        [conversation addParticipant:PFUser.currentUser];
        [conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:error.localizedDescription];
            } else {
                PFRelation *userRelation = [PFUser.currentUser relationForKey:kUserRelationConversation];
                [userRelation addObject:conversation];
                [PFUser.currentUser saveInBackground];
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate didTapAcceptDeclineButton:self.match];
            }
        }];
    }
}

- (IBAction)didTapDecline:(id)sender {
    PFRelation *userRelation = [PFUser.currentUser relationForKey:kUserRelationMatch];
    [userRelation removeObject:self.match];
    [PFUser.currentUser saveInBackground];
    PFRelation *matchRelation = [self.match relationForKey:kMatchMembersRelation];
    [matchRelation removeObject:PFUser.currentUser];
    [self.match saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate didTapAcceptDeclineButton:self.match];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellName forIndexPath:indexPath];
    PFUser *user = self.arrayOfUsers[indexPath.row];
    [cell setCell:user];
    return cell;
}

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
