//
//  RegisterViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/6/22.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *instrumentField;
@property (weak, nonatomic) IBOutlet UITextField *expertiseField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignUp:(id)sender {
    
    // Check if fileds are not empty
    if ([self.usernameField.text isEqualToString:@""] || [self.emailField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.repeatPasswordField.text isEqualToString:@""] || [self.instrumentField.text isEqualToString:@""] || [self.expertiseField.text isEqualToString:@""]) {
        
        [self alert:@"Please complete all required fields."];
        
    }
    else {
        
        PFUser *newUser = [PFUser new];
        
        newUser.username = self.usernameField.text;
        newUser.email = self.emailField.text;
        [newUser setObject:self.instrumentField.text forKey:@"instrumentType"];
        [newUser setObject:self.expertiseField.text forKey:@"expertiseLevel"];
        
        // Check if passwords match
        if ([self.passwordField.text isEqualToString:self.repeatPasswordField.text]) {
            
            newUser.password = self.passwordField.text;
            // Post new user to database
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error: %@", error.localizedDescription);
                } else {
                    NSLog(@"User registered successfully");
                }
            }];
            
        } else {
            
            [self alert:@"Password do not match."];
            
        }
    }
}

- (void)alert:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:message
                                   message:@""
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
