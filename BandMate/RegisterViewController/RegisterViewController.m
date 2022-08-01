//
//  RegisterViewController.m
//  BandMate
//
//  Created by Jose Castillo Guajardo on 7/6/22.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"

// Dropdown buttons
static NSArray *const kInstruments = @[@"Guitar", @"Bass", @"Singer", @"Drums"];
static NSArray *const kExpertiseLevels = @[@"Beginner", @"Intermidiate", @"Advanced"];
static NSString *const kDefaultInstrumentPopUp = @"Instrument Type";
static NSString *const kDefaultExpertisePopUp = @"Expertise Level";
// User table keys
static NSString *const kUserName = @"name";
static NSString *const kInstrumentType = @"instrumentType";
static NSString *const kExpertiseLevel = @"expertiseLevel";
// Segue after register name
static NSString *const kSegueAfterRegister = @"afterRegisterSegue";
// Syling dropdown
static CGFloat const kCornerRadius = 5;
static CGFloat const kBorderWidth = 0.1;
// Alerts
static NSString *const kMissingFields = @"Please complete all required fields.";
static NSString *const kPasswordMatch = @"Password do not match.";
static NSString *const kActionTitle = @"Ok";
// Empty string
static NSString *const kEmptyString = @"";

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *instrumentPopUp;
@property (weak, nonatomic) IBOutlet UIButton *expertisePopUp;
@property (strong, nonatomic) NSString *instrumentType;
@property (strong, nonatomic) NSString *expertiseLevel;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dropDownButtons];
}

- (void)dropDownButtons {
    UIAction *emptyInstrument = [UIAction actionWithTitle:kDefaultInstrumentPopUp image:NULL identifier:NULL handler:^(UIAction *action) {
        self.instrumentType = nil;
    }];
    UIAction *guitar = [UIAction actionWithTitle:kInstruments[0] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.instrumentType = kInstruments[0];
    }];
    UIAction *bass = [UIAction actionWithTitle:kInstruments[1] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.instrumentType = kInstruments[1];
    }];
    UIAction *singer = [UIAction actionWithTitle:kInstruments[2] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.instrumentType = kInstruments[2];
    }];
    UIAction *drums = [UIAction actionWithTitle:kInstruments[3] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.instrumentType = kInstruments[3];
    }];
    UIMenu *menuInstrument = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:emptyInstrument, guitar, bass, singer, drums, nil]];
    
    self.instrumentPopUp.layer.cornerRadius = kCornerRadius;
    self.instrumentPopUp.layer.borderWidth = kBorderWidth;
    self.instrumentPopUp.menu = menuInstrument;
    self.instrumentPopUp.showsMenuAsPrimaryAction = YES;
    self.instrumentPopUp.changesSelectionAsPrimaryAction = YES;
    
    UIAction *emptyExpertise = [UIAction actionWithTitle:kDefaultExpertisePopUp image:NULL identifier:NULL handler:^(UIAction *action) {
        self.expertiseLevel = nil;
    }];
    UIAction *beginner = [UIAction actionWithTitle:kExpertiseLevels[0] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.expertiseLevel = kExpertiseLevels[0];
    }];
    UIAction *intermediate = [UIAction actionWithTitle:kExpertiseLevels[1] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.expertiseLevel = kExpertiseLevels[1];
    }];
    UIAction *advanced = [UIAction actionWithTitle:kExpertiseLevels[2] image:NULL identifier:NULL handler:^(UIAction *action) {
        self.expertiseLevel = kExpertiseLevels[2];
    }];
    
    UIMenu *menuExpertise = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:emptyExpertise, beginner, intermediate, advanced, nil]];
    
    self.expertisePopUp.layer.cornerRadius = kCornerRadius;
    self.expertisePopUp.layer.borderWidth = kBorderWidth;
    self.expertisePopUp.menu = menuExpertise;
    self.expertisePopUp.showsMenuAsPrimaryAction = YES;
    self.expertisePopUp.changesSelectionAsPrimaryAction = YES;
}

- (IBAction)didTapSignUp:(id)sender {
    // Check if fileds are not empty
    if ([self.usernameField.text isEqualToString:kEmptyString] || [self.emailField.text isEqualToString:kEmptyString] || [self.passwordField.text isEqualToString:kEmptyString] ||
        [self.repeatPasswordField.text isEqualToString:kEmptyString] || [self.nameField.text isEqualToString:kEmptyString] || !self.instrumentType || !self.expertiseLevel) {
        [self alert:kMissingFields];
    }
    else {
        PFUser *newUser = [PFUser new];
        newUser.username = self.usernameField.text;
        newUser.email = self.emailField.text;
        [newUser setObject:self.nameField.text forKey:kUserName];
        [newUser setObject:self.instrumentType forKey:kInstrumentType];
        [newUser setObject:self.expertiseLevel forKey:kExpertiseLevel];
        // Check if passwords match
        if ([self.passwordField.text isEqualToString:self.repeatPasswordField.text]) {
            newUser.password = self.passwordField.text;
            // Post new user to database
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    [self alert:error.localizedDescription];
                } else {
                    [self performSegueWithIdentifier:kSegueAfterRegister sender:(id)sender];
                }
            }];
        } else {
            [self alert:kPasswordMatch];
        }
    }
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
