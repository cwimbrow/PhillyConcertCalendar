// PHLDetailViewController.m
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

#import "PHLDetailViewController.h"
#import "PHLCalendarEvent.h"

@interface PHLDetailViewController ()
- (void)configureView;
@end

@implementation PHLDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = (PHLCalendarEvent *)newDetailItem;

        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.bandsLabel.text = [self.detailItem headLiner];
        self.venueLabel.text = [self.detailItem venue];
        self.dateLabel.text = [self.detailItem showDate];
        self.priceLabel.text = [self.detailItem price];
        self.ticketUrlTextView.text = [[self.detailItem tixURL] absoluteString];
        self.saleDateLabel.text = [self.detailItem saleDate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
