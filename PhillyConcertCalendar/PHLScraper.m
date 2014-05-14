// PHLParser.m
//
// Copyright (c) 2014 Chris Wimbrow
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "PHLScraper.h"
#import "PHLCalendarEvent.h"
#import "TFHpple.h"


@implementation PHLScraper
- (NSMutableArray *)getConcertData
{
    NSURL *calendarUrl = [NSURL URLWithString:@"http://xpn.org/events/concert-calendar"];
    NSData *calendarHtmlData = [NSData dataWithContentsOfURL:calendarUrl];
    
    TFHpple *calendarScraper = [TFHpple hppleWithHTMLData:calendarHtmlData];
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:0];
    PHLCalendarEvent *show = nil;
    NSString *calendarXpathQueryString = @"//table[@class='arttable_table']/tbody/tr";
    NSArray *calendarNodes = [calendarScraper searchWithXPathQuery:calendarXpathQueryString];

    for (TFHppleElement *tr in calendarNodes) {
        show = [[PHLCalendarEvent alloc] init];

        TFHppleElement *bands = [tr firstChildWithClassName:@"cell1"];
        NSString *headLiner = [[bands firstChildWithTagName:@"b"] text];
        NSString *openers = [bands text];
        NSURL *tixURL = [NSURL URLWithString:
                         [[[tr firstChildWithClassName:@"cell5"]
                           firstChildWithTagName:@"a"]
                          objectForKey:@"href"]];
        [events addObject:show];
        show.day = [[tr firstChildWithClassName:@"cell-1"] text];
        show.showDate = [[tr firstChildWithClassName:@"cell0"] text];
        show.headLiner = headLiner;
        show.openers = openers;
        show.venue = [[tr firstChildWithClassName:@"cell2"] text];
        show.price = [[tr firstChildWithClassName:@"cell3"] text];
        show.saleDate = [[tr firstChildWithClassName:@"cell4"] text];
        show.tixURL = tixURL;
        show.showAges = [[tr firstChildWithClassName:@"cell6"] text];
        show.region = [[tr firstChildWithClassName:@"cell7"] text];
    }
    // NSLog(@"Added events: %lu", (unsigned long)[events count]);
    return events;
}
@end
