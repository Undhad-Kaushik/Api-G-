//
//  ViewController.swift
//  Api(G)
//
//  Created by undhad kaushik on 05/03/23.
//

import UIKit
import Alamofire
import FMDB


class ViewController: UIViewController {
    
    @IBOutlet weak var apiTabelView: UITableView!
    var arr: MAin!
    var arrMain: [MAin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibRegister()
        apiG()
        
    }
    private func nibRegister(){
        let nibRegister: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        apiTabelView.register(nibRegister, forCellReuseIdentifier: "cell")
        apiTabelView.separatorStyle = .none
        apiTabelView.delegate = self
        apiTabelView.dataSource = self
    }
    
    private func apiG(){
        AF.request("https://v2.jokeapi.dev/joke/Any?safe-mode",method: .get).responseData{ [self] response in
            debugPrint(response)
            if response.response?.statusCode == 200{
                guard let Apidata = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(MAin.self, from: Apidata)
                    print(result)
                    arr = result
                    arrMain = [arr]
                    apiTabelView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("Wrong")
            }
            
        }
    }
    
}

struct MAin: Decodable{
    var error: Bool
    var category: String
    var type: String
    var setup: String
    var delivery: String
    var flags: Flags
    var safe: Bool
    var id: Int
    var lang: String
}
struct Flags: Decodable{
    var nsfw: Bool
    var religious: Bool
    var political: Bool
    var racist: Bool
    var sexist: Bool
    var explicit: Bool
    
}


extension ViewController: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMain.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.label1.text = arrMain[indexPath.row].lang
        cell.label2.text = arrMain[indexPath.row].type
        cell.label3.text = arrMain[indexPath.row].category
        return cell
    }
}
