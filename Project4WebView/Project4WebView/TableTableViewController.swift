import UIKit

class TableTableViewController: UITableViewController {

    var webSites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webSites += ["apple.com","hackingwithswift.com"]
        title = "Super browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        cell.textLabel?.text = webSites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedSite") as? ViewController {
            vc.selectedWebSite = webSites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
