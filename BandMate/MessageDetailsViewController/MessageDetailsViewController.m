//
//  MessageDetailsViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/29/22.
//

#import "MessageDetailsViewController.h"

static CGFloat const kCornerRadius = 19;
// RGB Green
static CGFloat const kRed = 169/255.0;
static CGFloat const kGreen = 239/255.0;
static CGFloat const kBlue = 161.0/255.0;
static CGFloat const kAlpha = 1;
// nameLabel when sender is user
static NSString *const kNameLabel = @"You";
// Date format
static NSString *const kDateFormat = @"MM-dd-yyyy HH:mm";

@interface MessageDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([PFUser.currentUser.objectId isEqualToString:self.message.sender.objectId]) {
        self.nameLabel.text = kNameLabel;
        self.bubbleView.backgroundColor = [UIColor colorWithRed:kRed green:kGreen blue:kBlue alpha:kAlpha];
    } else {
        self.nameLabel.text = self.message.sender.username;
    }
    
    self.messageLabel.text = self.message.content;
    self.bubbleView.clipsToBounds = YES;
    self.bubbleView.layer.cornerRadius = kCornerRadius;
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:kDateFormat];
    NSString *date = [dateformate stringFromDate:[NSDate date]];
    self.dateLabel.text = date;
    
}

@end
