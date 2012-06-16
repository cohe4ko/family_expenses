//
//  ReportBoxView.m
//  Expenses
//

#import "ReportBoxView.h"
#import "ReportBoxTableViewCell.h"

@interface ReportBoxView (Private)
- (void)makeItems;
@end

@implementation ReportBoxView

@synthesize list;

#pragma mark -
#pragma mark Initializate

- (void)awakeFromNib {
	
	// Make items
	[self makeItems];
}

#pragma mark -
#pragma mark Make

- (void)makeItems {
	self.list = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark Setters

- (void)setList:(NSMutableArray *)_list {
	if (list != _list) {
		[list release];
		list = [_list retain];
	}
    [tableView reloadData];
}

#pragma mark -
#pragma mark UITableView data source

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 31.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifer = @"cellIdentifier";
	
	ReportBoxTableViewCell *cell = (ReportBoxTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifer];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReportBoxTableViewCell_iPhone" owner:self options:nil];
		cell = [nib objectAtIndex:0];
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_row_31.png"]] autorelease];
	}
	
	cell.item = [list objectAtIndex:indexPath.row];
	
	return cell;
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[list release];
	[tableView release];
	[super dealloc];
}

@end
