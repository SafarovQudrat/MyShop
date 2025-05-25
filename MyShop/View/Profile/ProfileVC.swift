import UIKit

class ProfileVC: UIViewController {
    
    private var backV: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        return v
    }()
    var profilImg: UIImageView = {
        let image = UIImageView()
        image.tintColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var nameLbl: UILabel = {
        let label = UILabel()
        label.text = "My Market"
        label.font = .customFont(.medium, 18)
        return label
    }()
    
    var tableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.isScrollEnabled = false
        t.register(UINib(nibName: "ProfileTVC", bundle: nil), forCellReuseIdentifier: "ProfileTVC")
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apparenceSettings()
        }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func apparenceSettings() {
        title = "Profil"
        view.backgroundColor = #colorLiteral(red: 0.1214147285, green: 0.2226163745, blue: 0.3583123684, alpha: 1)
        view.addSubview(backV)
        backV.addSubview(profilImg)
        backV.addSubview(nameLbl)
        backV.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        backV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        profilImg.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(24)
            make.width.height.equalTo(60)
        }
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(profilImg.snp_rightMargin).offset(24)
            make.centerY.equalTo(profilImg.snp_centerYWithinMargins)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profilImg.snp_bottomMargin).offset(24)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
