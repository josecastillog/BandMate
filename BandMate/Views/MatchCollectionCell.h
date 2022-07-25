//
//  MatchCollectionCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MatchCollectionCell : UICollectionViewCell
// Properties
@property (weak, nonatomic) IBOutlet PFImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) PFUser *user;
// Methods
- (void)setCell:(PFUser*)user;
@end

NS_ASSUME_NONNULL_END
