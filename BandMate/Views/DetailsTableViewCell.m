//
//  DetailsTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import "DetailsTableViewCell.h"

// Types of instruments
static NSArray *const kInstrumentTypeArray = @[@"Guitar", @"Drums", @"Singer", @"Bass"];
// User table keys
static NSString *const kUserName = @"name";
static NSString *const kUserUsername = @"username";
static NSString *const kUserInstrumentType = @"instrumentType";
static NSString *const kUserProfileImage = @"profileImage";
// Images
static NSString *const kDefaultUserImage = @"default-profile-icon-16";
static NSString *const kGuitarImage = @"guitar";
static NSString *const kBassImage = @"bass";
static NSString *const kSingerImage = @"music.mic";
static NSString *const kDrumsImage = @"drummer";

@implementation DetailsTableViewCell

typedef enum {
    Guitar,
    Drums,
    Singer,
    Bass
} Instrument;

- (Instrument) instrumentTypeStringToEnum:(NSString*)strInstrument {
    NSUInteger n = [kInstrumentTypeArray indexOfObject:strInstrument];
    return (Instrument) n;
}

- (void)setCell:(PFUser*)user {
    _user = user;
    
    self.nameLabel.text = [self.user objectForKey:kUserName];
    self.userLabel.text = [NSString stringWithFormat:@"@%@", [self.user objectForKey:kUserUsername]];
    self.instrumentLabel.text = [self.user objectForKey:kUserInstrumentType];
    
    self.profileImgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.height/2;
    self.profileImgView.layer.borderWidth = 0.1;
    self.profileImgView.clipsToBounds = YES;
    
    if ([self.user objectForKey:kUserProfileImage]) {
        self.profileImgView.file = [self.user objectForKey:kUserProfileImage];
        [self.profileImgView loadInBackground];
    } else {
        self.profileImgView.image = [UIImage imageNamed:kDefaultUserImage];
    }
    
    NSString *userInstrument = [self.user objectForKey:kUserInstrumentType];
    Instrument instrumentType = [self instrumentTypeStringToEnum:userInstrument];
    
    switch(instrumentType) {
        case Guitar:
            self.instrumentImgView.image = [UIImage imageNamed:kGuitarImage];
            break;
        case Drums:
            self.instrumentImgView.image = [UIImage imageNamed:kDrumsImage];
            break;
        case Singer:
            self.instrumentImgView.image = [UIImage systemImageNamed:kSingerImage];
            break;
        case Bass:
            self.instrumentImgView.image = [UIImage imageNamed:kBassImage];
            break;
    }
    
}

@end
