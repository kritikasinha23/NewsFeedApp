
import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var newsTableView: UITableView!
    
    var articleModel : ArticlesModel?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    func fetchData() {
        
        self.startShowLoadingAnimation()
        NetworkService.shared.readData(completion: { news, error in
            if let errorVal = error {
                print(errorVal.localizedDescription)
                return
            }
            guard let dataArray = news else {
                print("unable to fetch data")
                return
            }
            self.articleModel = dataArray
            DispatchQueue.main.async {
                self.stopLoadingAnimation()
                self.newsTableView.reloadData()
            }
        }, fromURLStr: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=763537cab3ad430da1e281d41fb2d44f")
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let newsData = articleModel.articles[indexPath.row]
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
        let article = articleModel?.articles[indexPath.row]
        let storyboard2 = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard2.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
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



