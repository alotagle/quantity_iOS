//
//  CollectionViewCell.h
//  Quantity
//
//  Created by Luis Carino  on 2/16/15.
//  Copyright (c) 2015 mx.unam.dgtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end
