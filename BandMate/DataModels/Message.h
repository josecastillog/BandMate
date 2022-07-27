//
//  Message.h
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/27/22.
//

#import <Parse/Parse.h>
#import "Conversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject<PFSubclassing>

// Properties
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) Conversation *conversation;
@property (nonatomic, strong) NSString *content;
// Methods
+ (Message*)initWithContent:(Conversation*)conversation :(NSString*)content;

@end

NS_ASSUME_NONNULL_END
