//
//  Message.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/27/22.
//

#import "Message.h"

static NSString *const kClassName = @"Message";
static NSString *const kMessageSender = @"sender";
static NSString *const kMessageContent = @"content";

@implementation Message

@dynamic createdAt;
@dynamic sender;
@dynamic conversation;
@dynamic content;

+ (nonnull NSString *)parseClassName {
    return kClassName;
}

+ (Message*)initWithContent:(Conversation*)conversation :(NSString*)content {
    Message *message = [[Message alloc] init];
    message.content = content;
    message.sender = PFUser.currentUser;
    message.conversation = conversation;
    return message;
}

+ (Message*)initWithPFObject:(PFObject*)object {
    Message *message = [[Message alloc] init];
    PFUser *user = [object objectForKey:kMessageSender];
    message.sender = user;
    message.content = [object objectForKey:kMessageContent];
    [user fetchIfNeeded];
    return message;
}

@end
