//
//  PHLDetailViewController.h
//  PhillyConcertCalendar
//
//  Created by Christopher Wimbrow on 5/14/14.
//  Copyright (c) 2014 Christopher Wimbrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHLDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
