//
//  STStoreDataController.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STStoreDataController.h"
#import "ICNetworkManager.h"

@interface STStoreDataController()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation STStoreDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _games = [NSMutableArray array];
        _hasMore = YES;
    }
    return self;
}

- (void)initFetchWithCompletion:(void (^)(NSArray<STGameModel *> *, NSError *))completionBlock
{
    if (self.isRequestOnAir) {
        return;
    }
    self.currentPage = 1;
    self.hasMore = YES;
    self.isRequestOnAir = YES;
    [ICNetworkManager requestApiPath:@"https://ckcz123.com/games/upload.php" method:@"GET" params:@{@"type": @"all", @"page": @(self.currentPage)} requestType:ICNetworkRequestTypeJSON withCompletionBlock:^(BOOL success, NSDictionary *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isRequestOnAir = NO;
            if (success) {
                if ([data[@"pages"] integerValue] == self.currentPage) {
                    self.hasMore = NO;
                }
                NSArray *result = [STGameModel modelsFromJSONArray:data[@"data"]];
                self.games = result.mutableCopy;
                if (completionBlock) {
                    completionBlock(result, nil);
                }
            } else {
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }
        });
    }];
}

- (void)loadMoreWithCompletion:(void (^)(NSArray<STGameModel *> *, NSError *))completionBlock
{
    if (self.isRequestOnAir) {
        return;
    }
    self.currentPage++;
    self.isRequestOnAir = YES;
    [ICNetworkManager requestApiPath:@"https://ckcz123.com/games/upload.php" method:@"GET" params:@{@"type": @"all", @"page": @(self.currentPage)} requestType:ICNetworkRequestTypeJSON withCompletionBlock:^(BOOL success, NSDictionary *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isRequestOnAir = NO;
            if (success) {
                if ([data[@"pages"] integerValue] == self.currentPage) {
                    self.hasMore = NO;
                }
                NSArray *result = [STGameModel modelsFromJSONArray:data[@"data"]];
                [self.games addObjectsFromArray:result];
                if (completionBlock) {
                    completionBlock(result, nil);
                }
            } else {
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }
        });
    }];
}

@end
