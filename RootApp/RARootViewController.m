#import "RARootViewController.h"
#import <spawn.h>

#import <sys/utsname.h>
extern CFTypeRef MGCopyAnswer(CFStringRef);
@interface RARootViewController ()<UIAlertViewDelegate>

@end
@implementation RARootViewController {
	NSMutableArray *_objects;
}

- (void)loadView {
	[super loadView];

	_objects = [NSMutableArray array];

	self.title = @"Root View Controller";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
}
int spawn(const char* executable, ...) {
    int     ret;
    pid_t   pid;
    va_list args;
    va_start(args, executable);
    ret = posix_spawn(&pid, executable, NULL, NULL, (char* const *)args, NULL);
    if (ret == 0) waitpid(pid, NULL, 0);
    return ret;
}

- (void)addButtonTapped:(id)sender {
	[_objects insertObject:[NSDate date] atIndex:0];
	[self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];

	 NSDictionary *dic = [self getDeviceInfo];
     NSLog(@"HardwareID %@",dic);
    
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:dic.description delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     [alert show];
	// NSLog(@"RootAppTest: %d, %d, %d", getuid(), geteuid(), spawn("/usr/bin/killall","/usr/bin/killall", "-9", "SpringBoard", NULL));
	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    id alertbutton = [alertView buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 1) {
        NSLog(@"RootAppTest: %d, %d, %d", getuid(), geteuid(), spawn("/usr/bin/killall","/usr/bin/killall", "-9", "SpringBoard", NULL));
    }
   
}
#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	NSDate *date = _objects[indexPath.row];
	cell.textLabel.text = date.description;
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[_objects removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//获取udid



/**
*
*/
- (NSDictionary*)getDeviceInfo{
   
    NSString *strUDID = [self getUDID];
    NSString *strSN = [self getSerialNumber];
    
    NSString *strWifiAddress = [self getWifiAddress];
    NSString *strBlueAddress = [self getBluetoothAddress];
    
    if (strUDID == nil) {
        strUDID = @" ";
    }
    
    if (strSN == nil) {
        strSN = @" ";
    }
    
    if (strWifiAddress == nil) {
        strWifiAddress = @" ";
    }
    
    if (strBlueAddress == nil) {
        strBlueAddress = @" ";
    }
    
    NSLog(@"RootAppTest: getuid——%d, geteuid——%d", getuid(), geteuid());
    
    NSMutableDictionary *dictDeviceInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           strUDID,@"UDID",
                                           strSN,@"SerialNumber",
                                           strWifiAddress,@"WifiAddress",
                                           strBlueAddress,@"BlueAddress",
                                           [NSString stringWithFormat:@"%d",getuid()],@"getuid()",
                                           [NSString stringWithFormat:@"%d",geteuid()],@"geteuid()",
                                           nil];
    return dictDeviceInfo;
}

-(NSString*)getUDID{
    
    NSString *str = @"UniqueDeviceID";
    CFStringRef result = MGCopyAnswer((__bridge CFStringRef)str);
    
    return (__bridge NSString *)(result);
}

-(NSString*)getSerialNumber{
    
    NSString *str = @"SerialNumber";
    CFStringRef result = MGCopyAnswer((__bridge CFStringRef)str);
    
    return (__bridge NSString *)(result);
}

-(NSString*) getIMEI{
    
    NSString *str = @"InternationalMobileEquipmentIdentity";
    CFStringRef result = MGCopyAnswer((__bridge CFStringRef)str);
    
    
    return (__bridge NSString *)(result);
}

-(NSString*) getWifiAddress{
    
    NSString *str = @"WifiAddress";
    CFStringRef result = MGCopyAnswer((__bridge CFStringRef)str);
    
    
    return (__bridge NSString *)(result);
}

-(NSString*) getBluetoothAddress{
    
    NSString *str = @"BluetoothAddress";
    CFStringRef result = MGCopyAnswer((__bridge CFStringRef)str);
    
    return (__bridge NSString *)(result);
}


@end
