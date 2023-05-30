//
//  PlayerViewController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/27/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UITextField!
    
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    // db is the reference to Firebase's database  that we imported using FirebaseFirestore
    
    let db = Firestore.firestore()
    
    var players: [PlayerListing] = []
    
    var selectedIndexPath: IndexPath?
    var selectedIndice = [IndexPath]()
    var indexPH: IndexPath?
    var rowPH2: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = false
        //custom design files must be registered inside the view controller that will use them
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        searchButton.setTitle("", for: .normal)
        
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        
        loadPlayers()
        
    }
    
    
    
    func loadPlayers () {
        
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.bibNumber)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.players = []
                
                
                if let e = error {
                    print("There was an error retreiving this data from Database: \(e)")
                }
                
                else {
                    //querySnapshot is a class inside of Firestore that stores all relevant data. documents is one property of QS and has a method called data that returns a Dictionary
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            
                            let dataFields = doc.data()
                            let docID = doc.documentID
                            
                            if let playerName = dataFields[K.FStore.name] as? String, let bibNumber = dataFields[K.FStore.bibNumber] as? Int {
                                
                                let documentID = docID
                                
                                
                                var newPlayer = PlayerListing(name: playerName, submissionId: bibNumber, documentID: documentID)
                                
                                newPlayer.position = dataFields[K.FStore.positions] as? String ?? "position"
                                newPlayer.city = dataFields[K.FStore.city] as? String ?? "City"
                                newPlayer.graduatingClass = dataFields[K.FStore.classOf] as? Int
                                newPlayer.State = dataFields[K.FStore.state] as? String ?? "State"
                                newPlayer.school = dataFields[K.FStore.school] as? String ?? "School"
                                
                                self.players.append(newPlayer)
                                
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                    //This section is responsible for scrolling to a specified part of the table view.
                                    
                                    //                                    let indexPath = IndexPath(row: self.players.startIndex, section: 0)
                                    //
                                    //                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                    
                                }
                                
                            } else {
                                
                                print("How could this be true AAND the array is clearly being populated?")
                            }
                            
                        }
                        
                    }
                }
            }
        
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        
        let confirmController = UIAlertController(title: "Leave This Station?", message: "Click Cancel if this was a mistake", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let yes = UIAlertAction(title: "Confirm", style: .default){_ in
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        confirmController.addAction(cancel)
        confirmController.addAction(yes)
        self.present(confirmController, animated: true)
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        
    }
    
    
    
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        if let playerSearch =  searchBar?.text{
            
            if Int(playerSearch) ?? 0 > 0 && Int(playerSearch) ?? 0 <= players.count {
                
                self.tableView.scrollToRow(at: IndexPath(row: (Int(playerSearch) ?? 1) - 1, section: 0), at: .top, animated: true)
                
            }}}
    
    
    
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            
        }
    }
    
    
    @objc func addComment(_ sender: UIButton) {
        
        
        let row = sender.tag
        
        rowPH2 = row
        
        let docID: String = self.players[rowPH2 ?? 0].documentID
        
        let alertController = UIAlertController(title: self.navigationItem.title, message: "Add Comment For This Player?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Begin Typing Here"
            
            alertController.view.backgroundColor = UIColor.systemGreen
        }
        
        
        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        
        //MARK: - Committing results via "SAVE" BUTTON
        
        let saveAction = UIAlertAction(title: "SAVE", style: .default) { _ in
            
            let eventResults = alertController.textFields![0].text
            
            self.db.collection(K.FStore.collectionName).document(docID).setData([
                "Coach Comment\(UUID())" : eventResults ?? ""], merge: true)
            
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)}
}
   

extension PlayerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for:indexPath) as! PlayerCell
       
        let collectionRef = self.db.collection(K.FStore.collectionName)
        let docID = self.players[indexPath.row].documentID
        let documentRef = collectionRef.document(docID)
        
   
        cell.commentButton.setTitle("", for: .normal)
        cell.commentButton.tag = indexPath.row
        cell.addPhoto.isHidden = true
        cell.playername.text = players[indexPath.row].name
        cell.graduatingClass.text = "\(players[indexPath.row].graduatingClass ?? 0000)"
        cell.position.text = players[indexPath.row].position ?? "position"
        cell.playerschool.text = players[indexPath.row].school
        cell.playerlocation.text = "\(players[indexPath.row].city ?? "City"),\(players[indexPath.row].State ?? "State")"
        cell.numberonChest.text = String(players[indexPath.row].submissionId)
        cell.playerSnapshot.image = UIImage(named: "MCS Logo no BG")
        cell.commentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
      
        
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                // If the value of the key in document.get(Key) is not empty, then execute the following code
                
                if let existingData: String = document.get(self.navigationItem.title ?? "") as? String, !existingData.isEmpty {
                    
                    cell.contentView.backgroundColor = UIColor(named: "mint")
                }
                
                else{
                    cell.contentView.backgroundColor = UIColor.white
                }
                
                
              //  return cell
            }}
        return cell
    }
}
        
        
extension PlayerViewController: UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let docID = self.players[indexPath.row].documentID
        let collectionRef = self.db.collection(K.FStore.collectionName)
        let documentRef = collectionRef.document(docID)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                // If the value of the key in document.get(Key) is not empty, then execute the following code
                
                if let existingData: String = document.get(self.navigationItem.title ?? "") as? String, !existingData.isEmpty {
                    
                    let confirmController = UIAlertController(title: "EDIT RESULTS?", message: "OVERWRITE PLAYER RESULTS?", preferredStyle: .alert)
                    
                    confirmController.addTextField { (textField) in
                        textField.placeholder = "This will overwrite previous results"
                        confirmController.view.backgroundColor = UIColor.systemYellow
                        confirmController.view.tintColor = UIColor.black
                        
                    }
                    
                    let newCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    let newSaveAction = UIAlertAction(title: "Save", style: .default) { _ in
                        
                        let newEventResults = confirmController.textFields![0].text
                        
                        self.db.collection(K.FStore.collectionName).document(docID).setData([
                            self.navigationItem.title ?? "" : newEventResults ?? ""], merge: true)
                        
                        
                    }
                    
                    confirmController.addAction(newSaveAction)
                    confirmController.addAction(newCancelAction)
                    self.present(confirmController, animated: true)
                    
                }
                
                else {
                    
                    let alertController = UIAlertController(title: self.navigationItem.title, message: "SUBMIT RESULTS", preferredStyle: .alert)
                    
                    alertController.addTextField { (textField) in
                        // configure the properties of the text field
                        textField.placeholder = "\(self.navigationItem.title ?? "Event") results"
                        
                        alertController.view.backgroundColor = UIColor.systemBlue
                    }
                    
                    
                    // add the buttons/actions to the view controller
                    let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
                    
                    
                    //MARK: - Committing results via "SAVE" BUTTON
                    
                    let saveAction = UIAlertAction(title: "SAVE", style: .default) { _ in
                        
                        let eventResults = alertController.textFields![0].text
                        
                        self.db.collection(K.FStore.collectionName).document(docID).setData([
                            self.navigationItem.title ?? "" : eventResults ?? ""], merge: true)
                        
                        
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(saveAction)
                    
                    self.present(alertController, animated: true, completion: nil)}}
            
            
            else {
                print("Document does not exist")
            }}
        
        
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if let playerSearch = searchBar.text{
            
            if Int(playerSearch) ?? 0 > 0 && Int(playerSearch) ?? 0 <= players.count{
                
                self.tableView.scrollToRow(at: IndexPath(row: (Int(playerSearch) ?? 1) - 1, section: 0), at: .top, animated: true)
                
                searchBar.endEditing(true)}
            
        }
        return true
    }
    }
    
    
    
    
    
    //MARK: - a portion of the code I wrote that would change the background color of each cell depending on whether or not that cell had already been selected and clicked "save on. Goes under the db merge under the "save" closure of confirm controller.
    //                                if let selectedPath = tableView.indexPathForSelectedRow {
    //                                    print("true")
    //                                    if let thisCell = tableView.cellForRow(at: selectedPath) as? PlayerCell{
    //                                        thisCell.contentView.backgroundColor = UIColor.systemGreen
    //
    //                                        self.selectedIndice.append(selectedPath)
    //
    //                                        self.indexPH = selectedPath
    //
    //                                        print("selected Indice: \(self.selectedIndice)")
    //
    //                                    }} else {
    //                                        print("This is where the problem is")
    //                                    }
    
    //MARK: - This section goes under the db merge function for the alertController
    //                                if let selectedPath = tableView.indexPathForSelectedRow {
    //                                    print("true")
    //                                    if let thisCell = tableView.cellForRow(at: selectedPath) as? PlayerCell{
    //                                        thisCell.contentView.backgroundColor = UIColor.systemGreen
    //
    //                                        self.selectedIndice.append(selectedPath)
    //
    //                                        self.indexPH = selectedPath
    //
    //                                        print("selected Indice: \(self.selectedIndice)")
    //
    //                                    }}

