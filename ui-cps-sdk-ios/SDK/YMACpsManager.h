//
//  YMACpsManager.h
//  ui-cps-sdk-ios
//
//  Created by mertvetcov on 30.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMASecureStorage.h"

/// Address of the page if successful payment authorization by credit card.
extern NSString *const kSuccessUrl;
/// Address of the page with the refusal to authorize payment by credit card.
extern NSString *const kFailUrl;

/// Completion of block is used to get the payment request info.
/// @param requestInfo - payment request info.
/// @param error - Error information or nil.
typedef void (^YMAStartPaymentHandler)(YMAPaymentRequestInfo *requestInfo, NSError *error);

/// Completion of block is used to get info about redirect to authorization page.
/// @param asc - info about redirect to authorization page.
/// @param error - Error information or nil.
typedef void (^YMAFinishPaymentHandler)(YMAAsc *asc, NSError *error);

/// Completion of block is used to get info about the money source.
/// @param moneySource - info about the money source (Information about the credit card).
/// @param error - Error information or nil.
typedef void (^YMAMoneySourceHandler)(YMAMoneySource *moneySource, NSError *error);

@interface YMACpsManager : NSObject

@property(nonatomic, strong, readonly) NSArray *moneySources;

- (id)initWithClientId:(NSString *)clientId;

- (void)updateInstanceWithCompletion:(YMAHandler)block;

- (void)saveMoneySourceWithRequestId:(NSString *)requestId completion:(YMAMoneySourceHandler)block;

- (void)removeMoneySource:(YMAMoneySource *)moneySource;

- (void)startPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams completion:(YMAStartPaymentHandler)block;

- (void)finishPaymentWithRequestId:(NSString *)requestId completion:(YMAFinishPaymentHandler)block;

- (void)finishPaymentWithRequestId:(NSString *)requestId moneySourceToken:(NSString *)moneySourceToken andCsc:(NSString *)csc completion:(YMAFinishPaymentHandler)block;

@end
