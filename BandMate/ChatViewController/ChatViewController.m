//
//  ChatViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/26/22.
//

#import "ChatViewController.h"
#import "ChatSendingTableViewCell.h"
#import "ChatRecievingTableViewCell.h"
#import "Message.h"
@import ParseLiveQuery;

// Cell identifiers
static NSString *const kSenderCell = @"sending";
static NSString *const kRecieverCell = @"recieving";
// Flipping table view and cells, scaling factors
static CGFloat const kXfactor = 1;
static CGFloat const kYfactor = -1;
// Styling settings
static CGFloat const kCornerRadius = 10;
static CGFloat const kBorderWidth = 1.5;
// Keyboard animation
static CGFloat const kDelay = 0;
static CGFloat const kDuration = 0.6;
// Message table keys
static NSString *const kMessageConversation = @"conversation";
static NSString *const kMessageSender = @"sender";
static NSString *const kMessageCreatedAt = @"createdAt";
// For send button
static NSString *const kEmptyString = @"";
static int const kIndexInsertion = 0;
// Query settings
static int const kQueryLimit = 20;

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTxtField;
@property (strong, nonatomic) NSMutableArray *arrayOfMessages;
@property (strong, nonatomic) PFLiveQueryClient *client;
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) PFLiveQuerySubscription *subscription;
@property (strong, nonatomic) Message *lastMessage;
@property BOOL isMoreDataLoading;
@property CGFloat originalHeight;
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
    self.messageTxtField.layer.cornerRadius = self.messageTxtField.frame.size.height/2;
    self.messageTxtField.layer.borderWidth = kBorderWidth;
    self.messageTxtField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Styling send button
    self.sendButton.clipsToBounds = YES;
    self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height/2;
    // Table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.transform = CGAffineTransformMakeScale (kXfactor, kYfactor);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.isMoreDataLoading = NO;
    // For returning view after keyboard dismiss
    self.originalHeight = self.view.frame.size.height;
    // Load conversation
    [self queryMessages];
    // Live Query setup
    [self liveQuerySetup];
    
}

#pragma mark - Queries

- (void)queryMessages {
    PFQuery *query = [Message query];
    [query whereKey:kMessageConversation equalTo:self.conversation];
    [query includeKey:kMessageSender];
    [query orderByDescending:kMessageCreatedAt];
    query.limit = kQueryLimit;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error loading messages: %@", [error localizedDescription]);
        } else {
            self.arrayOfMessages = [NSMutableArray arrayWithArray:objects];
            self.lastMessage = [self.arrayOfMessages lastObject];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData {
    PFQuery *query = [Message query];
    [query whereKey:kMessageConversation equalTo:self.conversation];
    [query whereKey:kMessageCreatedAt lessThan:self.lastMessage.createdAt];
    [query includeKey:kMessageSender];
    [query orderByDescending:kMessageCreatedAt];
    query.limit = kQueryLimit;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error loading messages: %@", [error localizedDescription]);
        } else {
                self.isMoreDataLoading = NO;
                [self.arrayOfMessages addObjectsFromArray:objects];
                self.lastMessage = [self.arrayOfMessages lastObject];
                [self.tableView reloadData];
        }
    }];
}

- (void)liveQuerySetup {
    self.client = [[PFLiveQueryClient alloc] init];
    self.query = [Message query];
    [self.query whereKey:kMessageConversation equalTo:self.conversation];
    self.subscription = [[self.client subscribeToQuery:self.query] addCreateHandler:^(PFQuery * query, PFObject *object) {
        Message *message = [Message initWithPFObject:object];
        if (![message.sender.objectId isEqual:PFUser.currentUser.objectId]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.arrayOfMessages insertObject:message atIndex:kIndexInsertion];
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.arrayOfMessages[indexPath.row];
    if ([message.sender.username isEqualToString:PFUser.currentUser.username]) {
        ChatSendingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSenderCell forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale(kXfactor, kYfactor);
        [cell setMessage:message];
        return cell;
    } else {
        ChatRecievingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kRecieverCell forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale(kXfactor, kYfactor);
        [cell setMessage:message];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading) {
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging && self.lastMessage) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
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

#pragma mark - Actions

- (IBAction)didTapSend:(id)sender {
    Message *message = [Message initWithContent:self.conversation :self.messageTxtField.text];
    [message saveInBackground];
    [self.arrayOfMessages insertObject:message atIndex:kIndexInsertion];
    self.messageTxtField.text = kEmptyString;
    [self.tableView reloadData];
}

@end
