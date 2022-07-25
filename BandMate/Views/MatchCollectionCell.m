//
//  MatchCollectionCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import "MatchCollectionCell.h"

// User table keys
static NSString *const kUserProfileImage = @"profileImage";
static NSString *const kUserName = @"name";
// Default user profile image
static NSString *const kDefaultProfileImage = @"default-profile-icon-16";
// Profile image settings
static double const kBorderWitdth = 0.1;

@implementation MatchCollectionCell

- (void)setCell:(PFUser *)user {
    
    _user = user;
    
    self.profileImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.height/2;
    self.profileImgView.layer.borderWidth = kBorderWitdth;
    self.profileImgView.clipsToBounds = YES;
    
    if (self.user.username == PFUser.currentUser.username) {
        self.nameLabel.text = @"You";
    } else {
        self.nameLabel.text = [user objectForKey:kUserName];
    }
    
    if ([self.user objectForKey:@"profileImage"]) {
        self.profileImgView.file = [self.user objectForKey:kUserProfileImage];
        [self.profileImgView loadInBackground];
    } else {
        self.profileImgView.image = [UIImage imageNamed:kDefaultProfileImage];
    }
    
}

@end
