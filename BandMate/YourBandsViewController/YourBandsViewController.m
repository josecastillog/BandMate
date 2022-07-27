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

// Table view
static NSString *const kCellName = @"ChatCell";
// User table keys
static NSString *const kUserConversations = @"conversations";

@interface YourBandsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfConversations;
@end

@implementation YourBandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self queryBands];
}

- (void)queryBands {
    PFRelation *relation = [PFUser.currentUser relationForKey:kUserConversations];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.arrayOfConversations = objects;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfConversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BandsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellName forIndexPath:indexPath];
    Conversation *conversation = self.arrayOfConversations[indexPath.row];
    [cell setCell:conversation];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChatViewController *chatViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Conversation *conversation = self.arrayOfConversations[indexPath.row];
    chatViewController.conversation = conversation;
}

@end
