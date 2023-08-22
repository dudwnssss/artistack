//
//  ProfileViewController.swift
//  ARTISTACK
//
//  Created by 임영준 on 2023/08/22.
//

import UIKit

class ProfileViewController: BaseViewController {

    let titleLabel = UILabel().then{
        $0.text = "프로필"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .white
    }
    
    let layout = UICollectionViewFlowLayout().then{
        let spacing : CGFloat = 10
        let width = UIScreen.main.bounds.width - (4 * spacing)
        $0.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        $0.itemSize = CGSize(width: width/3 , height: width/3 * 1.63)
//        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width , height: 44)
    }
    lazy var projectCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then{
        $0.register(cell: ProjectCell.self)
        $0.register(cell: ProfileCell.self)
        $0.register(ProjectHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProjectHeaderView.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    override func setLayouts() {
        view.backgroundColor = .systemIndigo
        view.addSubviews(projectCollectionView)
        projectCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setProperties() {
        setNavigationBar()
    }
    
    func setNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .lightGray
    }
}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profileCell: ProfileCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let projectCell: ProjectCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return indexPath.section == 0 ? profileCell : projectCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProjectHeaderView.reuseIdentifier, for: indexPath) as!
            ProjectHeaderView
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
}
