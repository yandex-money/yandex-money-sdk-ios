//
//  YMACscView.m
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACscView.h"
#import "YMAUIConstants.h"

@interface YMACscView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *cscTextField;
@property(nonatomic, strong) UILabel *cscLabel;
@property(nonatomic, assign) BOOL isEnabled;
@property(nonatomic, strong) UIView *footer;

@end

@implementation YMACscView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _isEnabled = YES;
        [self setupControls];
    }

    return self;
}

- (void)setupControls {
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIImageView *ymLogoView = [[UIImageView alloc] initWithImage:YMALocalizedImage(@"ym", nil)];
    CGRect logoRect = ymLogoView.frame;

    logoRect.origin.y = self.frame.size.height - 110;
    logoRect.origin.x = (self.frame.size.width - logoRect.size.width) / 2;
    ymLogoView.frame = logoRect;

    [self addSubview:ymLogoView];
}

- (void)layoutSubviews {
    [self setupDefaultNavigationBar];
}

- (void)setupDefaultNavigationBar {
    //TODO use image for back button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(showMoneySource)];
    leftBarButton.tintColor = [YMAUIConstants accentTextColor];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:YMALocalizedString(@"NBBPayment", nil) style:UIBarButtonItemStylePlain target:self action:@selector(startPayment)];
    rightBarButton.tintColor = [YMAUIConstants accentTextColor];
    
    [self.delegate updateNavigationBarTitle:@"" leftButtons:@[leftBarButton] rightButtons:@[rightBarButton]];
}

- (void)startPayment {
    [self.delegate disableError];
    [self.delegate startPaymentWithCsc:self.cscTextField.text];
    self.isEnabled = NO;
    self.cscTextField.enabled = NO;
    [self.tableView reloadData];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
    [self.delegate updateNavigationBarTitle:@"" leftButtons:@[] rightButtons:@[rightBarButton]];
}

- (void)stopPaymentWithError:(NSError *)error {
    self.isEnabled = YES;
    self.cscTextField.enabled = YES;
    [self.tableView reloadData];
    [self.delegate showError:error target:nil withAction:NULL];
    [self setupDefaultNavigationBar];
}

#pragma mark -
#pragma mark *** TableView  delegate ***
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kControlHeightWithTextField;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0) ? kControlHeightDefault : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return (section == 0) ? self.footer : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cscCellID";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    self.cscLabel.textColor = self.isEnabled ? [YMAUIConstants accentTextColor] : [YMAUIConstants commentColor];

    [cell.contentView addSubview:self.cscLabel];
    [cell.contentView addSubview:self.cscTextField];

    return cell;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [YMAUIConstants defaultBackgroundColor];
    }

    return _tableView;
}

- (UITextField *)cscTextField {
    if (!_cscTextField) {
        _cscTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, self.frame.size.width - 10, 44)];
        _cscTextField.placeholder = YMALocalizedString(@"TPRequired", nil);
    }

    return _cscTextField;
}

- (UILabel *)cscLabel {
    if (!_cscLabel) {
        _cscLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, self.frame.size.width - 20, 20)];
        _cscLabel.font = [YMAUIConstants commentFont];
        _cscLabel.text = YMALocalizedString(@"CTCsc", nil);
    }

    return _cscLabel;
}

- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kControlHeightDefault)];
        _footer.backgroundColor = [YMAUIConstants defaultBackgroundColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, kControlHeightDefault)];
        label.textColor = [YMAUIConstants commentColor];
        label.numberOfLines = 2;
        label.font = [YMAUIConstants commentFont];
        label.text = YMALocalizedString(@"TFCVVCode", nil);

        [_footer addSubview:label];
    }

    return _footer;
}

@end
