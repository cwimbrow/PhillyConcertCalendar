// PHLMasterViewController.m
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

#import "PHLMasterViewController.h"
#import "PHLDetailViewController.h"
#import "PHLScraper.h"
#import "PHLCalendarEvent.h"

@interface PHLMasterViewController () {
    NSMutableArray *_calendarEvents;
}
@end

@implementation PHLMasterViewController

- (void)loadCalendarEvents
{
    PHLScraper *scraper = [[PHLScraper alloc] init];
    _calendarEvents = [scraper getConcertData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *indicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicatorView];
    indicatorView.center = self.view.center;
    indicatorView.hidesWhenStopped = YES;
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    dispatch_queue_t scraperQueue = dispatch_queue_create("scraper", NULL);
    dispatch_async(scraperQueue, ^{
        [self loadCalendarEvents];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [indicatorView stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender
{
    if (!_calendarEvents) {
        _calendarEvents = [[NSMutableArray alloc] init];
    }
    [_calendarEvents insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View
- (NSMutableAttributedString *)makeBold:(NSString *)string
                        withRegularPart:(NSString *)nonBoldString
{
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *foregroundColor = [UIColor whiteColor];
    
    NSDictionary *attrs = @{boldFont: NSFontAttributeName,
                            foregroundColor: NSForegroundColorAttributeName};
    const NSRange range = NSMakeRange(0, string.length);
    NSString *fullString = [string stringByAppendingString:nonBoldString];
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullString];
    [attributedText setAttributes:attrs range:range];
    
    return attributedText;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _calendarEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    PHLCalendarEvent *event = _calendarEvents[indexPath.row];
    cell.textLabel.text = [event bands];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ @ %@", event.showDate, event.venue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_calendarEvents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PHLCalendarEvent *object = _calendarEvents[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
