//
//  ConnectionHelper.m
//  Quantity
//
//  Created by Luis Carino  on 2/15/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import "ConnectionHelper.h"

@implementation ConnectionHelper



//implementacion de los protocolos de conexion
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //se asignan a nil las properties utilizadas durante la conexion
    self.theConnection = nil;
    self.receivedData = nil;
    NSLog(@"Error: Conection did failed with error %@",error);
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.receivedData = [NSMutableData dataWithCapacity:0];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //se crea un string con la repsuesta del servidor
    NSString *response = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", response);
    NSError *myError = nil;
    
    // NSLog(@"After converting response to string %@",response);
    
    //Parseando la respuesta del servidor tipo JSON a un array
    self.theResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&myError];
    
    if(!myError){ //se parse correctamente
       
        switch (self.opcionNotificacion) {
            case LOGIN:
                [[NSNotificationCenter defaultCenter] postNotificationName:RECURSO_DESCARGADO object:nil userInfo:self.theResponse];
                break;
            case GET_PRODUCTS:
                [[NSNotificationCenter defaultCenter] postNotificationName:CATALOGO_DESCARGADO object:nil userInfo:self.theResponse];
                break;
            case SEND_RECEIPT:
                [[NSNotificationCenter defaultCenter] postNotificationName:RECIBO_ENVIADO object:nil userInfo:self.theResponse];
                break;
            default:
                break;
        }
        
        self.theConnection = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RECURSO_DESCARGADO object:nil];
    }else{
        NSLog(@"Se genero un error on Connection Did Finish %@",myError);
    }
}


-(void)consumeWebService:(NSString *)laUrl{
    
    NSString *urlString = laUrl;
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.theConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

@end
