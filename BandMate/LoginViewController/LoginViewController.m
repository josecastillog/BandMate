//
//  LoginViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/6/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapLogin:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [self alert:@"Please complete all required fields."];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"User log in failed: %@", error.localizedDescription);
                        [self alert:@"Incorrect username or password."];
                    } else {
                        NSLog(@"User logged in successfully");
                        [self performSegueWithIdentifier:@"afterLoginSegue" sender:(id)sender];
                    }
        }];
    }
    
}

- (void)alert:(NSString*)message  {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                   message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
