//
//  File.h
//  Calendar
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 Calendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject {
	id _delegate;
	SEL _selector;
}

+ (NSString *)rootDir;

+ (BOOL)makeDir:(NSString *)pathToDir;
+ (BOOL)copy:(NSString *)pathFrom to:(NSString *)pathTo;
+ (BOOL)move:(NSString *)pathFrom to:(NSString *)pathTo;
+ (BOOL)remove:(NSString *)pathTo;

+ (BOOL)checkAndMakeDir:(NSString *)pathToDir;

+ (id)readFile:(NSString *)pathToFile;
+ (BOOL)writeFile:(NSString *)pathToFile data:(NSData *)fileData;

- (void)remoteFileSize:(NSString *)url withDelegate:(id)delegate andSelector:(SEL)selector;

+ (BOOL)fileExists:(NSString *)pathToFile isDir:(BOOL)isDir;

@end
