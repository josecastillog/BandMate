//
//  MatchTableViewCell.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import "MatchTableViewCell.h"
#import "MatchCollectionCell.h"
#import "Artist.h"

// Artist table keys
static NSString *const kArtistArtistID = @"artistID";
// User table keys
static NSString *const kUserName = @"name";
static NSString *const kUserProfileImage = @"profileImage";
static NSString *const kObjectId = @"objectId";
// Match table keys
static NSString *const kMatchMembersRelation = @"members";
// Collection View Settings
static double const kMinimumLineSpacing = 0;
static double const kMinimumInteritemSpacing = 0;
static double const kCellWidth = 97.5;
static double const kCellHeight = 120;
static NSString *const kCellName = @"ImageCell";

@interface MatchTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) Artist *artist;
@property (strong, nonatomic) NSMutableArray *arrayOfUsers;
@end

@implementation MatchTableViewCell

// Methods
- (void)setCell:(Match*)match {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kMinimumLineSpacing;
    layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    self.collectionView.collectionViewLayout = layout;
    
    PFQuery *query = [Artist query];
    [query whereKey:kArtistArtistID equalTo:match.artistID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error retrieving artist: %@", [error localizedDescription]);
        } else {
            self.artist = [objects firstObject];
            self.matchLabel.text = self.artist.name;
        }
    }];
    
    PFRelation *relation = [match relationForKey:kMatchMembersRelation];
    PFQuery *queryMembers = [relation query];
    [queryMembers includeKey:kUserName];
    [queryMembers includeKey:kUserProfileImage];
    [queryMembers whereKey:kObjectId notEqualTo:PFUser.currentUser.objectId];
    
    [queryMembers findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error retrieving members: %@", [error localizedDescription]);
        } else {
            self.arrayOfUsers = [NSMutableArray arrayWithArray:objects];
            [self.arrayOfUsers insertObject:PFUser.currentUser atIndex:0];
            [self.collectionView reloadData];
        }
    }];
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfUsers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MatchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellName forIndexPath:indexPath];
    PFUser *user = self.arrayOfUsers[indexPath.row];
    [cell setCell:user];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kCellWidth, kCellHeight);
}

@end
