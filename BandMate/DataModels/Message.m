//
//  Message.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/27/22.
//

#import "Message.h"

static NSString *const kClassName = @"Message";

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

@end
