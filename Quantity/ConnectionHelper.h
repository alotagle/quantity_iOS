//
//  ConnectionHelper.h
//  Quantity
//
//  Created by Luis Carino  on 2/15/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RECURSO_DESCARGADO @"done"
#define CATALOGO_DESCARGADO @"done_downloading_products"
#define RECIBO_ENVIADO @"done_sending"
#define LOGIN 1
#define GET_PRODUCTS 2
#define SEND_RECEIPT 3

@interface ConnectionHelper : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property(nonatomic,strong) NSURLConnection *theConnection;
@property(nonatomic,strong) NSString *theUrl;
@property(nonatomic,strong) NSMutableData *receivedData;
@property(nonatomic,strong) NSDictionary *theResponse;

-(void)consumeWebService:(NSString *)laUrl;

@property int opcionNotificacion;



@end
