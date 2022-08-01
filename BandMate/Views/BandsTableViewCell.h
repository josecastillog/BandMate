//
//  BandsTableViewCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
#import "FBShimmeringView.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface BandsTableViewCell : UITableViewCell
// Properties
@property (weak, nonatomic) IBOutlet PFImageView *bandImgView;
@property (weak, nonatomic) IBOutlet UILabel *bandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
// Methods
- (void)setCell:(Conversation*)conversation;
- (void)setShimmering;
@end

NS_ASSUME_NONNULL_END
