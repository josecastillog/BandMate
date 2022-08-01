//
//  ChatViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import "ChatViewController.h"
#import "ChatSendingTableViewCell.h"
#import "ChatRecievingTableViewCell.h"

// For testing UI, will delete in future commits
static NSArray *const kArrayOfMessages = @[@"Hello", @"Hi!", @"How is it going?", @"going good hbu?", @"Good, thanks", @"Just working on the chat", @"Looking good so far just trying to get autolayout to work, apparently now it's working, let's see with this super long message", @"Looking good so far just trying to get autolayout to work, apparently know it's working, let's see with this super long message", @"For sure", @"Bye"];
// Cell identifiers
static NSString *const kSenderCell = @"sending";
static NSString *const kRecieverCell = @"recieving";
// Flipping table view and cells, scaling factors
static CGFloat const kXfactor = 1;
static CGFloat const kYfactor = -1;
// Styling settings
static CGFloat const kCornerRadius = 15;
static CGFloat const kBorderWidth = 0.1;
// Keyboard animation
static CGFloat const kDelay = 0;
static CGFloat const kDuration = 0.6;

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTxtField;
@property (strong, nonatomic) NSArray *arrayOfMessages;
@property CGFloat originalHeight;
// BOOL property for testing UI, will delete in future commits
@property BOOL swap;
@end

@implementation ChatViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Observers for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // To dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Styling text field
    self.messageTxtField.delegate = self;
    self.messageTxtField.clipsToBounds = YES;
    self.messageTxtField.layer.cornerRadius = kCornerRadius;
    self.messageTxtField.layer.borderWidth = kBorderWidth;
    // Styling send button
    self.sendButton.clipsToBounds = YES;
    self.sendButton.layer.cornerRadius = kCornerRadius;
    // Table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.transform = CGAffineTransformMakeScale (kXfactor, kYfactor);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // For returning view after keyboard dismiss
    self.originalHeight = self.view.frame.size.height;
    // Temporary for testing
    self.arrayOfMessages = kArrayOfMessages.reverseObjectEnumerator.allObjects;
    self.swap = YES;
    
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.swap) {
        ChatSendingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSenderCell forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale(kXfactor, kYfactor);
        [cell setMessage:self.arrayOfMessages[indexPath.row]];
        self.swap = NO;
        return cell;
    } else {
        ChatRecievingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kRecieverCell forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale(kXfactor, kYfactor);
        [cell setMessage:self.arrayOfMessages[indexPath.row]];
        self.swap = YES;
        return cell;
    }
}

#pragma mark - Keyboard Functions

- (void)dismissKeyboard {
       [self.messageTxtField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    if (self.view.frame.size.height == self.originalHeight) {
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        CGRect frame = self.view.frame;
        frame.size.height -= keyboardFrameBeginRect.size.height;
        [self animateKeyboard:frame];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if (self.view.frame.size.height != self.originalHeight) {
        CGRect frame = self.view.frame;
        frame.size.height = self.originalHeight;
        [self animateKeyboard:frame];
    }
}

- (void)animateKeyboard:(CGRect)frame {
    [UIView animateWithDuration:kDuration delay:kDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame = frame;
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
