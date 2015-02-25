//
//  ViewController.h
//  Quantity
//
//  Created by Luis Carino  on 2/15/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)buttonLogin:(id)sender;


@end

