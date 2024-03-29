/*
 *  DebugLog.m
 *  DebugLog
 *
 *  Created by Karl Kraft on 3/22/09.
 *  Copyright 2009 Karl Kraft. All rights reserved.
 *
 */

#include "DebugLog.h"

void _ALog(const char *file, int lineNumber, NSString *format,...) {
  va_list ap;
	
  va_start (ap, format);
  if (![format hasSuffix: @"\n"]) {
    format = [format stringByAppendingString: @"\n"];
	}
	NSString *body =  [[NSString alloc] initWithFormat: format arguments: ap];
	va_end (ap);
	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
	fprintf(stderr,"[%s:%d] %s",[fileName UTF8String],lineNumber,[body UTF8String]);
	
	//LOG_GENERAL(0,[NSString stringWithFormat:@"[%s:%d]  %s",[fileName UTF8String],lineNumber, [body UTF8String]],@"");
				
	[body release];	
}

