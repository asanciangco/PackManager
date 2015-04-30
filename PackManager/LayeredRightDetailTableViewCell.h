//
//  LayeredRightDetailTableViewCell.h
//  PackManager
//
//  Created by Heather Blockhus on 4/29/15.
//  Copyright (c) 2015 heather blockhus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayeredRightDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperDetailTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowerDetailTextLabel;

@end
