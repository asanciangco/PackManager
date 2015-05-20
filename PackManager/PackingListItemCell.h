//
//  PackingListItemCell.h
//  PackManager
//
//  Created by Heather Blockhus on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Packable.h"

@interface PackingListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;


@end