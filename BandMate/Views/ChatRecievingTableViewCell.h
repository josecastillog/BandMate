//
//  ChatRecievingTableViewCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRecievingTableViewCell : UITableViewCell
// Properties
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImgView;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (strong, nonatomic) Message *message;
// Methods
- (void)setMessage:(Message*)message;
@end

NS_ASSUME_NONNULL_END
