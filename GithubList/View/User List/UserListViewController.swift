//
//  UserListVC.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit
import SwiftUI

public class UserListViewController: UIViewController, UICollectionViewDelegate, EventDelegate, UISearchBarDelegate {
    
    @IBOutlet public private(set) weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let bottomInfoView = BottomInfoView(frame: CGRect.zero)
    var loadingIndicatorCell: LoadingIndicatorCell!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UserCellViewModel>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, UserCellViewModel>! = nil
    var selectedIndexPath: IndexPath!
    
    public let viewModel: UserListViewModel
    
    // MARK:  Lifecycle
    
    public required init?(coder: NSCoder, viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        let localLoader = LocalLoader(coreDataStack: AppDelegate.shared.coreDataStack)
        let compositeLoader = UsersLoaderComposite(localLoader: localLoader, remoteLoader: APILoader(client: URLSessionHTTPClient()))
        self.viewModel = UserListViewModel(service: compositeLoader)
        
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.loadData()
        title = "User List"
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedIndexPath != nil{
            //If selectedIndexPath not nil, it means that the indexPath has been selected. Reload collection view because data such as notes etc might be updated 
            viewModel.updateFilteredUsers(with: searchBar.text)
        }
    }
    
    func setupView(){
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        viewModel.delegate = self
        searchBar.delegate = self
    }
    
    func bind(){
        viewModel.onListLoad = {[weak self] users in
            self?.loadingIndicatorCell?.stopIndicatorAnimation()
            self?.display(users)
        }
    }
    
    // MARK:  Configure Collection View
    
    ///Create layout for the collection view.
    func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { index, env in
            //Layout item
            let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            
            //Root group with table layout
            let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item])
            
            //Setup section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            
            //Header and footer
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize:footerSize, elementKind:"loadingFooter", alignment: .bottom, absoluteOffset: CGPoint(x: 0, y: 0))
            
            section.boundarySupplementaryItems = [footer]
            
            return section
        }
        
        let config = layout.configuration
        config.scrollDirection = .vertical
        layout.configuration = config
        return layout
    }
    
    ///Configure datasource for the collection view
    func configureDataSource(){
        //Register cells
        let cellItemRegistration = UICollectionView.CellRegistration<UserCell, UserCellViewModel>{ (cell, indexPath, item) in
            cell.configure(user: item, indexPath: indexPath)
        }
        
        //Register footer cells
        let loadingFooterRegistration = UICollectionView.SupplementaryRegistration<LoadingIndicatorCell>(elementKind: "loadingFooter"){(suppView, kind, indexPath) in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, UserCellViewModel>(collectionView: collectionView) {(collectionView: UICollectionView, indexPath: IndexPath, item: UserCellViewModel) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellItemRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            var registrationView: UICollectionReusableView!
            if kind == "loadingFooter"{
                registrationView = self.collectionView.dequeueConfiguredReusableSupplementary(using: loadingFooterRegistration, for: indexPath)
                if let registrationView = registrationView as? LoadingIndicatorCell{
                    //Save the cell to local variable, so we can access it
                    self.loadingIndicatorCell = registrationView
                }
            }
            return registrationView
        }
    }
    
    func display(_ users: [UserCellViewModel], animate: Bool = false){
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, UserCellViewModel>()
        currentSnapshot.appendSections([0])
        currentSnapshot.appendItems(users)
        
        self.dataSource.apply(self.currentSnapshot, animatingDifferences: animate)
        selectedIndexPath = nil
    }
    
    // MARK:  Collection View delegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        //Here, if we are at bottom collection view and is not being filtered, show loading indicator animation then load next page
        if distanceFromBottom < height, !viewModel.isBeingFiltered() {
            loadingIndicatorCell?.showIndicator(flag: true)
            if !scrollView.isDragging{
                loadingIndicatorCell?.startIndicatorAnimation()
                viewModel.loadData(nextPage: true)
            }
        }else{
            loadingIndicatorCell?.showIndicator(flag: false)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = self.dataSource.itemIdentifier(for: indexPath) else{
            return
        }
        
        var profileView = UserProfileView()
        profileView.loginName = model.loginName
        profileView.avatarURL = model.avatarURL
        selectedIndexPath = indexPath
        //Open selected user profile view
        let vc = UIHostingController(rootView: profileView)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Event delegate
    
    public func handleNoInternetConnection() {
        bottomInfoView.showInfo("No Internet Connection", in: view, color: UIColor.red)
    }
    
    public func handleInternetConnectionRestored() {
        bottomInfoView.hideInfo()
    }

    // MARK: Search bar delegate
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateFilteredUsers(with: searchText)
    }
}
