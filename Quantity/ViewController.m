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

@interface ViewController () {
    NSString *username;
    NSString *password;
    NSString *elError;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginService:) name:RECURSO_DESCARGADO object:nil];
    
    elError = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonLogin:(id)sender {
    
    elError = @"";
    
    NSMutableString *loginUrl = [[NSMutableString alloc]initWithString:@"https://quantitydgtic.appspot.com/_ah/api/login/v1/loginUser?"];
    
    username = self.usernameField.text;
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    password = self.passwordField.text;
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username isEqual:@""]) {
        elError = @"Es necesario agregar un usuario";
    } else if([username length] < 5 || [username length] > 20) {
        elError = @"Longitud de usuario incorrecta, mínimo 5 y máximo 20";
    } else if([password isEqual:@""]) {
        elError = @"Es necesario agregar un password";
    } else if([password length] < 8 || [username length] > 20) {
        elError = @"Longitud de la contraseña incorrecta, mínimo 8 y máximo 20";
    }
    
    if ([elError isEqualToString:@""]) {
        NSString *urlParameters = [NSString stringWithFormat:@"password=%@&usuario=%@",password,username];
        [loginUrl appendString:urlParameters];
        
        ConnectionHelper *cn = [[ConnectionHelper alloc] init];
        cn.opcionNotificacion = 1; //LOGIN NOTIFICATION
        [cn consumeWebService:loginUrl];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:elError delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [av show];
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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Datos incorrectos" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [av show];
    }
}

// Método auxiliar para obtener el cifrado del password ingresado por el usuario
-(NSString *) sha1:(NSString *)input {
    
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
