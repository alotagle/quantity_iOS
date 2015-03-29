//
//  ItemsCollectionViewController.h
//  Quantity
//
//  Created by Luis Carino  on 2/24/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PRODUCTO_SELECCIONADO @"seleccionado"

@interface ItemsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property NSArray *productosarray;
@property NSMutableDictionary *productosDictionaries;

@end
