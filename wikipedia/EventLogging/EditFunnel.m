//
//  EditFunnel.m
//  Wikipedia
//
//  Created by Brion on 5/28/14.
//  Copyright (c) 2014 Wikimedia Foundation. Some rights reserved.
//

#import "EditFunnel.h"
#import "WikipediaAppUtils.h"
#import "SessionSingleton.h"

@implementation EditFunnel

-(id)init
{
    // https://meta.wikimedia.org/wiki/Schema:MobileWikiAppEdit
    self = [super initWithSchema:@"MobileWikiAppEdit" version:8198182];
    if (self) {
        self.editSessionToken = [self singleUseUUID];
    }
    return self;
}

-(NSDictionary *)preprocessData:(NSDictionary *)eventData
{
    NSMutableDictionary *dict = [eventData mutableCopy];
    dict[@"editSessionToken"] = self.editSessionToken;
    NSString *userName = [SessionSingleton sharedInstance].keychainCredentials.userName;
    dict[@"userName"] = userName ? userName : @"";
    //dict[@"pageNS"] = @0; // @todo allow other types or ...? // Android doesn't send this?
    return [NSDictionary dictionaryWithDictionary: dict];
}

#pragma mark - EditFunnel methods

-(void)logStart
{
    [self log:@{@"action": @"start"}];
}

-(void)logPreview
{
    [self log:@{@"action": @"preview"}];
}

-(void)logSavedRevision:(int)revID
{
    NSNumber *revIDNumber = [NSNumber numberWithInt:revID];
    [self log:@{@"action": @"saved",
                @"revID": (revIDNumber ? revIDNumber : @"")}];
}

-(void)logLoginAttempt
{
    [self log:@{@"action": @"loginAttempt"}];
}

-(void)logLoginSuccess
{
    [self log:@{@"action": @"loginSuccess"}];
}

-(void)logLoginFailure
{
    [self log:@{@"action": @"loginFailure"}];
}

-(void)logCaptchaShown
{
    [self log:@{@"action": @"captchaShown"}];
}

- (void)logCaptchaFailure
{
    [self log:@{@"action": @"captchaFailure"}];
}

- (void)logAbuseFilterWarning:(NSString *)code
{
    [self log:@{@"action": @"abuseFilterWarning",
                @"abuseFilterCode": (code ? code : @"")}];
}

- (void)logAbuseFilterError:(NSString *)code
{
    [self log:@{@"action": @"abuseFilterError",
                @"abuseFilterCode": (code ? code : @"")}];
}

-(void)logAbuseFilterWarningIgnore:(NSString *)code
{
    [self log:@{@"action": @"abuseFilterWarningIgnore",
                @"abuseFilterCode": (code ? code : @"")}];
}

-(void)logAbuseFilterWarningBack:(NSString *)code
{
    [self log:@{@"action": @"abuseFilterWarningBack",
                @"abuseFilterCode": (code ? code : @"")}];
}

- (void)logSaveAnonExplicit
{
    [self log:@{@"action": @"saveAnonExplicit"}];
}

- (void)logError:(NSString *)code
{
    [self log:@{@"action": @"error",
                @"errorText": (code ? code : @"")}];
}

@end