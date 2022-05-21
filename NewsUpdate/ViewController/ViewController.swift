
import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var newsTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var articleModel : ArticlesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            newsTableView.refreshControl = refreshControl
        } else {
            newsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        fetchData()
    }
    func fetchData() {
        
        self.startShowLoadingAnimation()
        NetworkService.shared.readData(fromURLStr: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=763537cab3ad430da1e281d41fb2d44f", type: ArticlesModel.self, completion: { news, error in
            DispatchQueue.main.async {
                self.stopLoadingAnimation()
                self.refreshControl.endRefreshing()
                if let errorVal = error {
                    print(errorVal.localizedDescription)
                    return
                }
                guard let dataArray = news else {
                    print("unable to fetch data")
                    return
                }
                self.articleModel = dataArray
                
                
                self.newsTableView.reloadData()
            }
        })
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        guard let article = articleModel?.articles[indexPath.row] else {
            return cell
        }
        cell.authorLabel.text = article.author
        cell.titleLabel.text = article.title
        cell.descriptionLabel.text = article.articleDescription
        guard let urlStr = article.urlToImage, let  url  = URL(string: urlStr) else {
            return cell
        }
        cell.newsImage.kf.setImage(with: url)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = articleModel?.articles[indexPath.row] else {
            return
        }
        let storyboard2 = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard2.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.articleInfo = article
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func startShowLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.loadingView.isHidden = false
        }
    }
    
    func stopLoadingAnimation() {
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
            }
    }
    
    
}



