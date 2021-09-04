//
//  TableViewController.swift
//  Toilets
//
//  Created by Muhammad Mehdi Raza on 6/5/20.
//  Copyright © 2020 Muhammad Mehdi Raza. All rights reserved.
//

import UIKit
import SystemConfiguration


class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //instance variables
    var toiletList = [Toilet]()
    var male: Bool = false
    var female: Bool = false
    var wheelchair: Bool = false
    var baby: Bool = false
    
    var searchedData = [Toilet]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.showSpinner()
        
        //checking if internet is available or not
        if !showAlert() {
            
            let anonymousFunction = { (fetchedToiletList: [Toilet]) in
                
                //filtering data based on filters
                DispatchQueue.main.async{
                    self.toiletList = fetchedToiletList
                    
                    if (self.male)
                    {
                        self.toiletList = self.toiletList.filter{$0.male == "yes"}
                    }
                    else
                    {
                        self.toiletList = self.toiletList.filter{$0.male == "no"}
                    }
                    if (self.female)
                    {
                        self.toiletList = self.toiletList.filter{$0.female == "yes"}
                    }
                    else
                    {
                        self.toiletList = self.toiletList.filter{$0.female == "no"}
                    }
                    if (self.wheelchair)
                    {
                        self.toiletList = self.toiletList.filter{$0.wheelchair == "yes"}
                    }
                    else
                    {
                        self.toiletList = self.toiletList.filter{$0.wheelchair == "no"}
                    }
                    if (self.baby)
                    {
                        self.toiletList = self.toiletList.filter{$0.baby_facil == "yes"}
                    }
                    else
                    {
                        self.toiletList = self.toiletList.filter{$0.baby_facil == "no"}
                    }
                    
                    //checking if there are no toilets to display
                    self.checkToilet()
                                        
                    self.tableView.reloadData()
                }
            }
            
            ToiletAPI.shared.fetchToiletList(onCompletion: anonymousFunction)
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //shwoing alert if there are no toilets in list
    func checkToilet(){
        
        if self.toiletList.count == 0 {
            
            let alert = UIAlertController(title: "Warning", message: "No Toilets found with current filters", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Okay", style: .default, handler: { action in self.noToilet()})
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //taking user back to filters screen in case NO toilets were fetched
    func noToilet(){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "InitViewController") as? InitViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //if user enters text in searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        self.searching = true
        
        if (searchText.count > 0){
        
        self.searchedData = self.toiletList.filter({$0.name.lowercased().contains(searchText.lowercased())})
        
        }
        else{
            self.searchedData = self.toiletList
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    //if user press cancel button of searchbar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }

    //checking if internet is available
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    //showing alert in case internet is not available
    func showAlert() -> Bool {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Exit", style: .default, handler: { action in self.noInternet()})
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    //exiting app if no internet is available
    func noInternet(){
        exit(-1)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //checking if user is searching or not
        if searching{
            return searchedData.count
        }
        else{
            return toiletList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
                
        //if user is searching, populating the searched list only or whole fetched list otherwise
        if searching{
            
            let toilet = searchedData[indexPath.row]
            
            //splitting toilet name to get name and address separately
            let add = toilet.name.split(separator: "-")
            
            if String(add[1]).lowercased().contains("toilet")
            {
                cell.textLabel?.text = String(add[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                cell.detailTextLabel?.text = String(add[2])
            }
            else{
                cell.textLabel?.text = String(add[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                cell.detailTextLabel?.text = String(add[1])
            }
        }
        else{
            
            let toilet = toiletList[indexPath.row]
            
            //splitting toilet name to get name and address separately
            let add = toilet.name.split(separator: "-")
            
            if String(add[1]).lowercased().contains("toilet")
            {
                cell.textLabel?.text = String(add[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                cell.detailTextLabel?.text = String(add[2])
            }
            else{
                cell.textLabel?.text = String(add[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                cell.detailTextLabel?.text = String(add[1])
            }
        }
        
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let toilet = toiletList[indexPath.row]
        let add = toilet.name.split(separator: "-")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        if String(add[1]).lowercased().contains("toilet")
        {
            vc?.namelbl = String(add[1]).trimmingCharacters(in: .whitespacesAndNewlines)
            vc?.addresslbl = String(add[2])
        }
        else{
            vc?.namelbl = String(add[0]).trimmingCharacters(in: .whitespacesAndNewlines)
            vc?.addresslbl = String(add[1])
        }
        
        vc?.long = toilet.lon
        vc?.lat = toilet.lat
        vc?.malelbl = toilet.male ?? "N/A"
        vc?.femalelbl = toilet.female ?? "N/A"
        vc?.babylbl = toilet.baby_facil
        vc?.wheelchairlbl = toilet.wheelchair ?? "N/A"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
