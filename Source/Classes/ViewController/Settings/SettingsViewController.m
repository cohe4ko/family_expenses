//
//  SettingsViewController.m
//  Expenses
//
//  Created by Vinogradov Sergey on 10.10.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "SettingsViewController.h"
#import "TransactionsController.h"
#import "PickerCurrencyViewController.h"
#import "PickerPasswordViewController.h"
#import "PasswordViewController.h"
#import "BudgetController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSLocale+Currency.h"
#import "SettingsController.h"


@interface SettingsViewController (Private)
- (void)makeToolBar;
- (void)makeLocale;
- (void)makeItems;
- (void)updateList;
- (void)setData;
- (void)sentDatabaseByEmail;
- (void)loadCurrencyPicker;
- (void)loadPasswordPicker;
- (void)passwordUpdate;
@end

@implementation SettingsViewController

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionCurrencyChanged:)
                                                 name:NOTIFICATION_CURRENCY_UPDATE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passwordUpdate)
                                                 name:NOTIFICATION_PASSWORD_UPDATE
                                               object:nil];
    
	// Make toolbar
	[self makeToolBar];
	
	// Make locale
	[self makeLocale];
	
	// Make items
	[self makeItems];
	
	// Set data
	[self setData];
}

#pragma mark -
#pragma mark Make

- (void)makeToolBar {
	
}

- (void)makeLocale {
	
}

- (void)makeItems {
	
	[self updateList];
    tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorColor = [UIColor colorWithRed:77.0/255.0 green:31.0/255.0 blue:23.0/255.0 alpha:1.0];

	
	// Set data
    [self setData];
}

#pragma mark -
#pragma mark UITableView delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [self loadPasswordPicker];
            }else if(indexPath.row == 1) {
                [self loadCurrencyPicker];
            }
            break;
        }
        case 1:
            break;
        case 2:{
            if (indexPath.row == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"settings_alert_title", @"")
                                           message:NSLocalizedString(@"settings_clear_database_message", @"")
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"settings_alert_no", @"")
                                 otherButtonTitles:NSLocalizedString(@"settings_alert_ok", @""), nil];
                [alertView show];
                [alertView release];
            }else if(indexPath.row == 1) {
                [self sentDatabaseByEmail];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        [TransactionsController clearTransactions];
        [BudgetController clearBudget];

        [UIAlertView showMessage:NSLocalizedString(@"settings_alert_title", @"")
                      forMessage:NSLocalizedString(@"settings_clear_database_done", @"")
                  forButtonTitle:NSLocalizedString(@"settings_alert_close", @"")];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TRANSACTIONS_UPDATE object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BUDGET_UPDATE object:nil];
    }
}

#pragma mark -
#pragma mark MFMailComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultSent) {
        [UIAlertView showMessage:NSLocalizedString(@"settings_alert_title", @"")
                      forMessage:NSLocalizedString(@"settings_send_database_success", @"") forButtonTitle:NSLocalizedString(@"settings_alert_close", @"")];
    }else if(result == MFMailComposeResultFailed) {
        [UIAlertView showMessage:NSLocalizedString(@"settings_alert_title", @"")
                      forMessage:NSLocalizedString(@"settings_send_database_error", @"") forButtonTitle:NSLocalizedString(@"settings_alert_close", @"")];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -

#pragma mark -
#pragma mark Actions
- (void)actionCurrencyChanged:(NSNotification*)notification{
    [self updateList];
    [tableView reloadData];
}

#pragma mark -
#pragma mark Set

- (void)setData {
	
	// Reload tableview
	[tableView reloadData];
}

- (void)setLogo{
    [self setTitle:NSLocalizedString(@"nav_settings", @"")];
}

- (void)updateList{
    // Init array
    if (list) {
        [list removeAllObjects];
    }else {
        list = [[NSMutableArray alloc] init];
    }
	
    NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"settings_settings",@"title", @"icon_settings_settings.png", @"icon", nil];
	NSMutableArray *settingsArray = [NSMutableArray array];
    [settingsArray addObject:[NSArray arrayWithObjects:@"password",@"", nil]];
    NSInteger currencyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"settings_currency_index"];
    NSDictionary *currencyDic = [SettingsController currencyForIndex:currencyIndex];
	[settingsArray addObject:[NSArray arrayWithObjects:@"currency",[currencyDic objectForKey:kCurrencyKeySymbol], nil]];
    [settingsDic setObject:settingsArray forKey:@"list"];
    [list addObject:settingsDic];
    
    NSMutableDictionary *devicesDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"settings_devices", @"title", @"icon_settings_device.png", @"icon", nil];
    NSMutableArray *devicesArray = [NSMutableArray array];
    [devicesArray addObject:[NSArray arrayWithObjects:@"devices",@"", nil]];
    [devicesDic setObject:devicesArray forKey:@"list"];
    [list addObject:devicesDic];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"settings_database", @"title", @"icon_settings_database.png", @"icon", nil];
    NSMutableArray *sendArray = [NSMutableArray array];
    [sendArray addObject:[NSArray arrayWithObjects:@"clear_database",@"", nil]];
    [sendArray addObject:[NSArray arrayWithObjects:@"send_by_email",@"", nil]];
    [sendDic setObject:sendArray forKey:@"list"];
    [list addObject:sendDic];
}

#pragma mark -
#pragma mark Private
- (void)sentDatabaseByEmail{
    if ([MFMailComposeViewController canSendMail]) {
        NSString *dbPath = [[Db shared] path];
        if (dbPath && [[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
            NSData *data = [NSData dataWithContentsOfFile:dbPath];
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setSubject:NSLocalizedString(@"settings_send_database_subject", @"")];
            [mailController setMessageBody:NSLocalizedString(@"settings_send_database_content", @"") isHTML:NO];
            [mailController addAttachmentData:data mimeType:@"sqlite" fileName:[dbPath lastPathComponent]];
            [[(AppDelegate*)[UIApplication sharedApplication].delegate tabBarController] presentModalViewController:mailController animated:YES];
            mailController.mailComposeDelegate = self;
            [mailController release];
        }
    }else {
        [UIAlertView showMessage:NSLocalizedString(@"settings_alert_title", @"")
                      forMessage:NSLocalizedString(@"settings_send_database_cant", @"") forButtonTitle:NSLocalizedString(@"settings_alert_close", @"")];
    }
}

- (void)loadCurrencyPicker{
    PickerCurrencyViewController *currencyViewController = [MainController getViewController:@"PickerCurrencyViewController"];
    [[RootViewController shared] presentModalViewController:currencyViewController animated:YES];
}

- (void)loadPasswordPicker{
    PickerPasswordViewController *passwordViewController = [MainController getViewController:@"PickerPasswordViewController"];
    [[RootViewController shared] presentModalViewController:passwordViewController animated:YES];
}

- (void)passwordUpdate{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password_session"];
    PasswordViewController *passwordController = [MainController getViewController:@"PasswordViewController"];
    passwordController.editType = PasswordEditTypeAdd;
    [[RootViewController shared] presentModalViewController:passwordController animated:NO];
}

#pragma mark -

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)dealloc {
	[list release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end