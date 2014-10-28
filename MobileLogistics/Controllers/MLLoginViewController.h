//
//  MLLoginViewController.h
//  MobileLogistics
//
//  Created by shane davis on 27/10/2014.
//  Copyright (c) 2014 shane davis. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MLloginViewControllerDelegate <NSObject>
-(void)userLoginWithcredentials:(NSDictionary*)credentials completion:(void(^)(NSError*))completion;
@end

@interface MLLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property id<MLloginViewControllerDelegate> delegate;
- (IBAction)loginUser:(id)sender;
@end
