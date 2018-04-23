//
//  STGameModel.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STGameModel.h"
#import "NSArray+Map.h"

@implementation STGameModel

+ (instancetype)modelFromJSON:(NSDictionary *)json
{
    STGameModel *model = [[STGameModel alloc] init];
    model.gameID = json[@"id"];
    model.titleName = json[@"title"];
    model.identifierName = json[@"name"];
    model.version = json[@"version"];
    model.originAuthor = json[@"author"];
    model.copiedAuthor = json[@"author2"];
    model.webURLString = json[@"link"];
    model.imageURL = [NSURL URLWithString:json[@"image"]];
    model.descriptionString = json[@"description"];
    model.extraInfo = json[@"content"];
    model.score = [json[@"score"] floatValue];
    model.playerCount = [json[@"people"] integerValue];
    model.winnerCount = [json[@"win"] integerValue];
    model.lastWinnerDate = [NSDate dateWithTimeIntervalSince1970:[json[@"lasttime"] integerValue]];
    model.createDate = [NSDate dateWithTimeIntervalSince1970:[json[@"createtime"] integerValue]];
    model.updateDate = [NSDate dateWithTimeIntervalSince1970:[json[@"updatetime"] integerValue]];
    model.tags = [json[@"tag"] componentsSeparatedByString:@"|"];
    
    return model;
}

+ (NSArray<STGameModel *> *)modelsFromJSONArray:(NSArray *)jsonArray
{
    return [jsonArray mapWithBlock:^id(id item, NSInteger index) {
        return [self modelFromJSON:item];
    }];
}

- (NSURL *)localRootURL
{
    NSString *rootPath = [[STGameModel allGamesRootPath] stringByAppendingPathComponent:self.gameID];
    return [NSURL fileURLWithPath:rootPath];
}

- (NSURL *)thumbURL
{
    NSString *imageURLString = self.imageURL.absoluteString;
    return [NSURL URLWithString:[[[imageURLString stringByDeletingPathExtension] stringByAppendingString:@".min"] stringByAppendingPathExtension:[imageURLString pathExtension]]];
}

- (NSURL *)downloadURL
{
    return [NSURL URLWithString:[self.webURLString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.identifierName]]];
}

+ (NSString *)allGamesRootPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths.firstObject;
    return documentPath;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    STGameModel *model = object;
    return [self.gameID isEqualToString:model.gameID];
}

@end
