//
//  ChatViewController.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (strong, nonatomic) Conversation *conversation;
@end

NS_ASSUME_NONNULL_END
