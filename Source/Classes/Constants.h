//
//  Constants.h
//  Expenses
//
//  Created by Vinogradov Sergey on 14.04.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

// General
#define DATABASE							@"db.sqlite"
#define DATABASE_VERSION					@"1.0.0.2"
#define HOST								@"www.apple.com"
#define HOST_URL							@"https://"HOST@"/"
#define UDID								[[UIDevice currentDevice] uniqueIdentifier]
#define VERSION_OS							[[UIDevice currentDevice] systemVersion]
#define DEVICE_NAME							@"iPhone"//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone"
#define IS_IPAD								NO//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)	

// API
 
// Length fields
#define LENGTH_MAX_DEFAULT					80
#define LENGTH_MAX_LOGIN					15
#define LENGTH_MAX_PASSWORD					20
#define LENGTH_MAX_SEARCH					255

// Other
#define KEYBOARD_ANIMATION_DURATION			0.3f
#define CREATE_TMP_TRANSACTIONS				NO

// Notifications
#define NOTIFICATION_CONTACTS_UPDATE		@"NOTIFICATION_CONTACTS_UPDATE"
#define NOTIFICATION_UPDATE					@"NOTIFICATION_UPDATE"
#define NOTIFICATION_CHECK_UPDATE			@"NOTIFICATION_CHECK_UPDATE"
#define NOTIFICATION_TRANSACTIONS_UPDATE	@"NOTIFICATION_TRANSACTIONS_UPDATE"
#define NOTIFICATION_REPORT_UPDATE          @"NOTIFICATION_REPORT_UPDATE"
#define NOTIFICATION_BUDGET_UPDATE			@"NOTIFICATION_BUDGET_UPDATE"
#define NOTIFICATION_CURRENCY_UPDATE        @"NOTIFICATION_CURRENCY_UPDATE"
#define NOTIFICATION_PASSWORD_UPDATE        @"NOTIFICATION_PASSWORD_UPDATE"
#define NOTIFICATION_PASSWORD_CORRECT       @"NOTIFICATION_PASSWORD_CORRECT"
#define NOTIFICATION_PASSWORD_CANCELED      @"NOTIFICATION_PASSWORD_CANCELED"

// Types
typedef enum {
    SortSumm		= 1,
	SortDate		= 2,
	SortCategores	= 3
} SortType;

typedef enum {
    GroupDay        = 1,
    GroupWeek       = 2,
    GroupMonth      = 3,
    GroupInfin      = 4
} GroupType;

typedef enum {
    SegmentedLeft	= 0,
	SegmentedCenter	= 1,
	SegmentedRight	= 2,
} SegmentedState;