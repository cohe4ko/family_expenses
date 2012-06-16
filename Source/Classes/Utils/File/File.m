//
//  File.m
//  AmAm
//
//  Created by Vinogradov Sergey on 10.04.10.
//  Copyright 2010 Calendar. All rights reserved.
//

#import "File.h"

@implementation File

BOOL LOG = 0;

/*
 * Метод получения пути к корневой папке
 *
 * @return NSString
 */
+ (NSString *)rootDir {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

/*
 * Метод создания папки
 *
 * @param NSString pathToDir - путь к создаваемой папки
 * @return BOOL
 */
+ (BOOL)makeDir:(NSString *)pathToDir {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	BOOL success = YES;
	BOOL isDir = YES;
	
	if(![fileMgr fileExistsAtPath:pathToDir isDirectory:&isDir]) {
		if([fileMgr createDirectoryAtPath:pathToDir withIntermediateDirectories:YES attributes:nil error:nil]) {
			if (LOG)
				NSLog(@"Succes: Folder %@ create", pathToDir);
		}
		else {
			success = NO;
			if (LOG)
				NSLog(@"Error: Create folder %@ failed", pathToDir);
		}
	}
	
	return success;
	[fileMgr release];
}

/*
 * Метод копирования папки / файла
 *
 * @param NSString pathFrom - путь от куда копируем папку / файл
 * @param NSString pathTo - путь куда копируем папку / файл
 * @return BOOL
 */
+ (BOOL)copy:(NSString *)pathFrom to:(NSString *)pathTo {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	BOOL success = NO;
	
	if ([fileMgr copyItemAtPath:pathFrom toPath:pathTo error:nil]) {
		if (LOG) 
			NSLog(@"Success: Moved from %@ to %@", pathFrom, pathTo);
		success = YES;
	}
	else {
		if (LOG)
			NSLog(@"Error: Move %@ to %@ failed", pathFrom, pathTo);
	}
	
	return success;
}

/*
 * Метод переноса папки / файла
 *
 * @param NSString pathFrom - путь от куда переносим папку / файл
 * @param NSString pathTo - путь куда переносим папку / файл
 * @return BOOL
 */
+ (BOOL)move:(NSString *)pathFrom to:(NSString *)pathTo {
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	BOOL success = NO;
	
	if ([fileMgr moveItemAtPath:pathFrom toPath:pathTo error:nil]) {
		if (LOG) 
			NSLog(@"Success: Moved from %@ to %@", pathFrom, pathTo);
		success = YES;
	}
	else {
		if (LOG)
			NSLog(@"Error: Move %@ to %@ failed", pathFrom, pathTo);
	}
	
	return success;
}

/*
 * Метод удаления папки
 *
 * @param NSString pathTo - путь к удаляемой папки / файла
 * @return BOOL
 */
+ (BOOL)remove:(NSString *)pathTo {
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	BOOL success = NO;
	
	if ([fileMgr removeItemAtPath:pathTo error:nil]) {
		if (LOG) 
			NSLog(@"Success: %@ remove success", pathTo);
		success = YES;
	}
	else {
		if (LOG)
			NSLog(@"Error: %@ remove failed", pathTo);
	}
	
	return success;
}

/*
 * Метод рекурсивной проверки пути к папке и ее создания
 *
 * @param NSString pathToDir - путь к папке
 * @return BOOL
 */
+ (BOOL)checkAndMakeDir:(NSString *)pathToDir {
	BOOL success = YES;
	
	NSString *dir = @"";
 	NSArray *arrDir = [pathToDir componentsSeparatedByString:@"/"];
	NSEnumerator *key = [arrDir objectEnumerator];
	
	id obj;
	while(obj = [key nextObject]) {
		if (success) {
			dir = [NSString stringWithFormat:@"%@%@/", dir, obj];
			success = [File makeDir:dir];
		}
	}
	return success;
}

/*
 * Метод считывания данных файла
 *
 * @param NSString pathFile - путь к сохраняемому файлу
 * @param NSData fileData - содержимое файла
 * @return BOOL
 */
+ (id)readFile:(NSString *)pathToFile {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	BOOL isDir = NO;
	
	// Проверяем существует ли файл
	if ([fileMgr fileExistsAtPath:pathToFile isDirectory:&isDir]) {
		
		// Загружаем данные с файла
		NSData *fileData = [fileMgr contentsAtPath: pathToFile];
		return fileData;
	}
	
	return nil;
}

/*
 * Метод сохранения файла в файловую систему
 *
 * @param NSString pathFile - путь у сохраняемому файлу
 * @param NSData fileData - содержимое файла
 * @return BOOL
 */
+ (BOOL)writeFile:(NSString *)pathToFile data:(NSData *)fileData {
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	BOOL success = NO;
	BOOL isDir = NO;
	
	if (![fileMgr fileExistsAtPath:pathToFile isDirectory:&isDir]) {
		if ([fileMgr createFileAtPath:pathToFile contents:fileData attributes: nil]) {
			if (LOG) 
				NSLog(@"Success: File %@ created", pathToFile);
			success = YES;
		}
		else {
			if (LOG)
				NSLog(@"Error: Create folder %@ failed", pathToFile);
		}
	}
	
	return success;
	
	[fileMgr release];
}

+ (BOOL)fileExists:(NSString *)pathToFile isDir:(BOOL)isDir {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	return [fileMgr fileExistsAtPath:pathToFile isDirectory:&isDir];
}

- (void)remoteFileSize:(NSString *)url withDelegate:(id)delegate andSelector:(SEL)selector {
	_delegate = [delegate retain];
	_selector = selector;
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[connection cancel];
    float size = (float)[response expectedContentLength];
	if (_delegate && [_delegate respondsToSelector:_selector]) {
		[_delegate performSelector:_selector withObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:size] forKey:@"size"]];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if (_delegate && [_delegate respondsToSelector:_selector]) {
		[_delegate performSelector:_selector withObject:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
	}
}

- (void)dealloc {
	[_delegate release];
	[super dealloc];
}

@end
