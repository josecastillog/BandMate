//
//  YourBandsViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import "YourBandsViewController.h"
#import "BandsTableViewCell.h"
#import "Conversation.h"
#import "ChatViewController.h"
#import "FBShimmeringView.h"

// Table view
static NSString *const kCellName = @"ChatCell";
// User table keys
static NSString *const kUserConversations = @"conversations";
// Shimmering
static int const kNumberOfCells = 3;
// Animation
static CGFloat const kStartingAlpha = 0;
static CGFloat const kEndingAlpha = 1;
static CGFloat const kDuration = 0.5;
// Refresh Control index
static int const kIndex = 0;

@interface YourBandsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfConversations;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property BOOL isLoaded;
@end

@implementation YourBandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryBands) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:kIndex];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self queryBands];
}

- (void)queryBands {
    self.isLoaded = NO;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    PFRelation *relation = [PFUser.currentUser relationForKey:kUserConversations];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.arrayOfConversations = objects;
        self.isLoaded = YES;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isLoaded) {
        return kNumberOfCells;
    }
    return self.arrayOfConversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BandsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellName forIndexPath:indexPath];
    if (!self.isLoaded) {
        [cell setShimmering];
        return cell;
    }
    Conversation *conversation = self.arrayOfConversations[indexPath.row];
    [cell setCell:conversation];
    return cell;
}

- (void)tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoaded) {
        cell.alpha = kStartingAlpha;
        [UIView animateWithDuration:kDuration animations:^{
                cell.alpha = kEndingAlpha;
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChatViewController *chatViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Conversation *conversation = self.arrayOfConversations[indexPath.row];
    chatViewController.conversation = conversation;
}

@end
