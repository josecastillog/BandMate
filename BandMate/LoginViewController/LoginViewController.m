//
//  LoginViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/6/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

static NSString *const KEmptyString = @"";
// Alerts
static NSString *const kAlertTitle = @"Error";
static NSString *const kAlertActionTitle = @"Ok";
static NSString *const kCompleteFieldsAlert = @"Please complete all required fields.";
// Segue
static NSString *const kSegueIdentifier = @"afterLoginSegue";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapLogin:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if ([username isEqualToString:KEmptyString] || [password isEqualToString:KEmptyString]) {
        [self alert:kCompleteFieldsAlert];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                    if (error != nil) {
                        [self alert:error.localizedDescription];
                    } else {
                        [self performSegueWithIdentifier:kSegueIdentifier sender:(id)sender];
                    }
        }];
    }
    
}

- (void)alert:(NSString*)message  {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:kAlertTitle
                                   message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kAlertActionTitle style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
