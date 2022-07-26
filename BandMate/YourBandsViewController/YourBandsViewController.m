//
//  YourBandsViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/25/22.
//

#import "YourBandsViewController.h"
#import "BandsTableViewCell.h"

// Table view
static NSString *const kCellName = @"ChatCell";
// User table keys
static NSString *const kUserCurrentBands = @"currentBands";

@interface YourBandsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfBands;
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
    PFRelation *relation = [PFUser.currentUser relationForKey:kUserCurrentBands];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.arrayOfBands = objects;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BandsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellName forIndexPath:indexPath];
    Match *match = self.arrayOfBands[indexPath.row];
    [cell setCell:match];
    return cell;
}

@end
