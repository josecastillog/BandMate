//
//  ProfileViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/7/22.
//

#import "ProfileViewController.h"
#import "ProfileTableCell.h"
#import "Parse/Parse.h"
#import "Artist.h"
#import "SceneDelegate.h"
@import Parse;

// User table keys
static NSString *const kUserInstrumentType = @"instrumentType";
static NSString *const kUserName = @"name";
static NSString *const kUserUsername = @"username";
static NSString *const kUserProfileImage = @"profileImage";
// Alerts
static NSString *const kActionTitle = @"Ok";
static NSString *const kEmptyString = @"";

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instrumentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSArray *arrayOfArtists;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self queryTopArtists];
    [self setupProfile];
}

- (void)setupProfile {
    // Profile image interaction
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.imgView addGestureRecognizer:tapGesture];
    self.imgView.userInteractionEnabled = YES;
    // Labels
    self.nameLabel.text = [PFUser.currentUser objectForKey:kUserName];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", [PFUser.currentUser objectForKey:kUserUsername]];
    self.instrumentLabel.text = [PFUser.currentUser objectForKey:kUserInstrumentType];
    // Profile image
    self.imgView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.imgView.layer.cornerRadius = self.imgView.frame.size.height/2;
    self.imgView.layer.borderWidth = 0.1;
    self.imgView.clipsToBounds = YES;
    [self setProfileImage];
}

- (void)tapGesture: (id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.imgView setImage:image];
    [PFUser.currentUser setObject:[self getPFFileFromImage:image] forKey:kUserProfileImage];
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self alert:error.localizedDescription];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)setProfileImage {
    if (PFUser.currentUser[@"profileImage"]) {
        self.imgView.file = PFUser.currentUser[kUserProfileImage];
        [self.imgView loadInBackground];
    }
}

- (void)queryTopArtists {
    PFQuery *query = [Artist query];
    [query whereKey:@"artistID" containedIn: [PFUser.currentUser objectForKey: @"fav_artists"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [self alert:error.localizedDescription];
        } else {
            self.arrayOfArtists = objects;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.arrayOfArtists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileCell"
                                                                 forIndexPath:indexPath];
    Artist *artist = self.arrayOfArtists[indexPath.row];
    [cell setArtist:artist];
    return cell;
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            [self alert:error.localizedDescription];
        } else {
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        }
    }];
}

- (void)alert:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:message
                                   message:kEmptyString
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kActionTitle style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
