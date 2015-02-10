//
//  FriendsListTableViewController.m
//  DemoAfeez
//
//  Created by Developer on 10/02/15.
//
//

#import <FacebookSDK/FacebookSDK.h>
#import "FriendsListTableViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface FriendsListTableViewController ()

@property (nonatomic, strong) NSArray *friendsListArray;

@end

@implementation FriendsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Getting friends..", nil)];
    /* make the API call */
    
    [FBRequestConnection startWithGraphPath:@"/me/friends"
//    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if (!error) {
                                  /* handle the result */
                                  _friendsListArray = result[@"data"];
                                  [self.tableView reloadData];
                                  [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", nil)];
                              }else{
                                  //show localized description
                                  [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                              }
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _friendsListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendProfileCell" forIndexPath:indexPath];
    
    // Configure the cell...
    id <FBGraphUser> fbUserData = _friendsListArray[indexPath.row];
    NSString *imageUrlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", fbUserData[@"id"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"userPlaceHolder.png"]];
    cell.textLabel.text = fbUserData[@"name"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
