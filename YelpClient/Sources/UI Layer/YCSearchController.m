//
//  ViewController.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-09.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCSearchController.h"
#import "YCBusinessDetailsController.h"
#import "AutoLayoutHelper.h"
#import "YCBusinessCell.h"
#import "YCYelpAPIConnector.h"
#import "YCBusiness.h"
#import "YCReview.h"

static NSString *reuseIdentifier = @"BusinessCell";

@interface YCSearchController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *loadingLabel;

@property (nonatomic, strong) NSArray<YCBusiness *> *searchResults;

@end

@implementation YCSearchController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSearchBar];
    [self addCollectionView];

    UILabel *loadingLabel = [[UILabel alloc] init];
    [self.view addSubview:loadingLabel];
    self.loadingLabel = loadingLabel;
    [AutoLayoutHelper centerView:loadingLabel superview:self.view];

    [self performSearch];
}

- (void) addSearchBar {
    UISearchBar *seachBar = [UISearchBar new];
    self.searchBar = seachBar;
    [self.searchBar sizeToFit];
    [self.searchBar setBarTintColor:self.navigationController.navigationBar.barTintColor];

    [self.searchBar setText:@"Ethiopian"];
    [self.searchBar setDelegate:self];
    self.navigationItem.titleView = self.searchBar;
}

- (void) addCollectionView {
    const CGFloat margin = 10;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(190, 170)];

    [layout setMinimumLineSpacing:margin];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setContentInset:UIEdgeInsetsMake(margin, margin, margin, margin)];
    [collectionView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];

    UINib *businessCell = [UINib nibWithNibName:NSStringFromClass([YCBusinessCell class]) bundle:nil];
    [collectionView registerNib:businessCell forCellWithReuseIdentifier:reuseIdentifier];

    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

    [AutoLayoutHelper pinAllEdgesOfView:collectionView toSuperview:self.view edgeInset:UIEdgeInsetsZero];
}

- (void) performSearch {
    [self.loadingLabel setAlpha:1.0];
    [self.loadingLabel setEnabled:YES];
    [self.loadingLabel setText:@"Searching..."];
    [self.collectionView setAlpha:0];


    [YCBusiness findBusinessesWithSearchTerm:self.searchBar.text withSorting:YCSortHighestRated completion:^(NSArray<YCBusiness *> * _Nonnull businesses) {

        if (businesses.count > 0) {

            [UIView animateWithDuration:0.5 animations:^{
                [self.loadingLabel setAlpha:0];
                [self.collectionView setAlpha:1];
            } completion:^(BOOL finished) {
                [self.loadingLabel setEnabled:NO];
                self.searchResults = businesses;
                [self.collectionView reloadData];
            }];

        } else {
            [self.loadingLabel setText:@"No Search Results"];
        }
    } failure:^(NSError *error) {
        // Do some error handling...Its a bit outside of the scope of this assignement
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UISearchBar Delegate

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self performSearch];
    [searchBar resignFirstResponder];
}

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCBusinessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (!cell) {
        cell = [[YCBusinessCell alloc] init];
    }

    YCBusiness *business = self.searchResults[indexPath.row];
    [cell updateWithBusiness:business];

    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCBusiness *business = self.searchResults[indexPath.row];
    YCBusinessDetailsController *detailsController = [[YCBusinessDetailsController alloc] initWithBusiness:business];
    [self.navigationController pushViewController:detailsController animated:YES];
}

@end
