//
//  PHLCalendarEvent.h
//  Philly Concert Calendar
//
//  Created by Christopher Wimbrow on 5/11/14.
//  Copyright (c) 2014 Christopher Wimbrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHLCalendarEvent : NSObject
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *showDate;
@property (nonatomic, strong) NSString *headLiner;
@property (nonatomic, strong) NSString *openers;
@property (nonatomic, strong) NSString *venue;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *saleDate;
@property (nonatomic, strong) NSURL *tixURL;
@property (nonatomic, strong) NSString *showAges;
@property (nonatomic, strong) NSString *region;
@end
