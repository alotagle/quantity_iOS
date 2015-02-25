//
//  ViewController.m
//  Quantity
//
//  Created by Luis Carino  on 2/15/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ConnectionHelper.h"

@interface ViewController (){
    NSString *username;
    NSString *password;
    NSString *elError;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginService:) name:RECURSO_DESCARGADO object:nil];
    
    elError = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (IBAction)buttonLogin:(id)sender {
    
    
    NSMutableString *loginUrl = [[NSMutableString alloc]initWithString:@"https://quantitydgtic.appspot.com/_ah/api/login/v1/loginUser?"];
    
    username = self.usernameField.text;
    password = self.passwordField.text;
    
    
    if ([username isEqual:@""]) {
        elError = @"Es necesario agregar un usuario";
    } else if([password isEqual:@""]) {
        elError = @"Es necesario agregar un password";
    }
    
    if (![elError isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:elError delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    } else {
        NSString *urlParameters = [NSString stringWithFormat:@"password=%@&usuario=%@",password,username];
        [loginUrl appendString:urlParameters];
        
        ConnectionHelper *cn = [[ConnectionHelper alloc] init];
        cn.opcionNotificacion = 1; //LOGIN NOTIFICATION
        [cn consumeWebService:loginUrl];
    }
}

- (void) loginService: (NSNotification *)laNotificacion {
    NSDictionary *response = [laNotificacion userInfo];
    NSString *respuesta = [response objectForKey:@"respuesta"];

    if ([respuesta integerValue]) {
        //Logeo exitoso se redirije al view controller principal y se cre una sesion para el usuario
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:username forKey:@"username"];
        [defaults setObject:password forKey:@"password"];
        [defaults synchronize];
        
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Datos incorrectos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

//metodo axuliar para obtener el cifrado del password ingreasado por el usuario
-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
