//
//  UserCollectionTableViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "UserCollectionTableViewController.h"
#import "DataBaseHelper.h"
#import "DetailModel.h"
#import "UIImageView+WebCache.h"
#import "MovieStepViewController.h"
#import "PictureViewController.h"
#import "DetailTableViewCell.h"

#import "MainDataBaseHelper.h"
#import "DownDetileModel.h"
#import "NextDownViewController.h"
#import "HeaderView.h"

#import "UIImageView+WebCache.h"
#import "DetailStepTableViewCell.h"
#import "MeiShi.h"
@interface UserCollectionTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *tableView;

@end

@implementation UserCollectionTableViewController

- (void)dealloc {
    self.text = nil;
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setPrivateNaviBar];
    [self registerCell];
}

/**
 *  设置导航栏的私有属性
 */
- (void)setPrivateNaviBar {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = self.text;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}



/**
 *  注册cell
 */
- (void)registerCell {
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DetailStepTableViewCell class] forCellReuseIdentifier:@"shouye"];
    [self.view addSubview:_tableView];
    [_tableView release];
    [_tableView reloadData];
}

/**
 *  点击返回按钮返回到上一个界面
 */
//- (void)handleBack {
//    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController popViewControllerAnimated:YES];

//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
        return [DataBaseHelper numberOfRowAtSection];
//    }
//    return [MainDataBaseHelper numberOfRowAtSection1];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        DetailModel *model = [DataBaseHelper modelAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        if (model.Duration.length != 0) {
            cell.videoImage.image = [UIImage imageNamed:@"jingxuanshipin"];
        }
        return cell;
//    }
//    DetailStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shouye" forIndexPath:indexPath];
//    DownDetileModel *model = [MainDataBaseHelper modelAtIndexPath1:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.stepIntro.text = model.title;
//    [cell.stepPhoto sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"meishi5"]];
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
        DetailModel *model = [DataBaseHelper modelAtIndexPath:indexPath];
        if (model.Duration.length != 0) {
            MovieStepViewController *mStepVC = [[MovieStepViewController alloc] init];
            mStepVC.receiveModel = model;
            mStepVC.recipedId = [NSString stringWithFormat:@"%@",model.RecipeId];
            [self.navigationController pushViewController:mStepVC animated:YES];
            self.tabBarController.tabBar.hidden = YES;
            [mStepVC release];
        } else {
            PictureViewController *picVC = [[PictureViewController alloc] init];
            picVC.receiveModel = model;
            picVC.recipedId = [NSString stringWithFormat:@"%@",model.RecipeId];
            [self.navigationController pushViewController:picVC animated:YES];
            self.tabBarController.tabBar.hidden = YES;
            [picVC release];
        }
//    } else {
//        DownDetileModel *model = [MainDataBaseHelper modelAtIndexPath1:indexPath];
//        NextDownViewController *nextDownVC = [[NextDownViewController alloc] init];
//        nextDownVC.dashes_name = model.title;
//        nextDownVC.text = [model.dishes_id stringValue];
//        [self.navigationController pushViewController:nextDownVC animated:YES];
//        [nextDownVC release];
//    }
//    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
       return  WIDTH  / 6 + WIDTH / 20;
//    }
//    return WIDTH  / 6 + WIDTH / 20;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"列表收藏";
//    }
//    return @"首页收藏";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 10)] autorelease];
//    if (section == 0) {
        headView.headerLabel.text = @"分类收藏";
        return headView;
//    }
//    headView.headerLabel.text = @"推荐收藏";
//    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return WIDTH  / 10;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        if (indexPath.section == 0) {
            [DataBaseHelper deleteModelInSection:indexPath];
//        } else {
//            [MainDataBaseHelper deleteModelInSection1:indexPath];
//        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section == 0) {
        [DataBaseHelper moveFromIndexPath:fromIndexPath ToIndexPath:toIndexPath];
    } else {
        [MainDataBaseHelper moveFromIndexPath1:fromIndexPath ToIndexPath1:toIndexPath];
    }
}
*/


// Override to support conditional rearranging of the table view.
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == proposedDestinationIndexPath.section) {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
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
