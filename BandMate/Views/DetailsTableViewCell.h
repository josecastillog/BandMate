//
//  DetailsTableViewCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/24/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface DetailsTableViewCell : UITableViewCell
// Properties
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *instrumentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *instrumentImgView;
// Methods
- (void)setCell:(PFUser*)user;
@end

NS_ASSUME_NONNULL_END
