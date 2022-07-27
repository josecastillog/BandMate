//
//  ChatTableViewCell.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatSendingTableViewCell : UITableViewCell
// Properties
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
// Methods
- (void)setMessage:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
