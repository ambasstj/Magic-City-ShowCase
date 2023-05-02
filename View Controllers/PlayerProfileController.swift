//
//  PlayerProfileController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/28/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage


class PlayerProfileController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var addAthleteButton: UIButton!
    
    
    // db is the reference to Firebase's database  that we imported using FirebaseFirestore
    let db = Firestore.firestore()
    //creates root reference to FirebaseStorage
    let storageRef = Storage.storage().reference()
    // An image picker controller manages user interactions and delivers the results of those interactions to a delegate object. The role and appearance of an image picker controller depend on the source type you assign to it before you present it.
    var imagePicker: UIImagePickerController?
    // a placeholder i'm using to capture the image picked by the user using UIImagePickerController that will then be uploaded to firebase storage
    var selectedPhoto: UIImage!
    // a variable i'm using associate the "take photo" button with the cell it lives in, I'm using .tag to append a property "tag" with the value of (indexPath.row) in my CellForRowAt method
    var rowPH: Int?
    
    //my array of player objects
    var players: [PlayerListing] = []
    //using this variable to pass the value of the selected index over to the playerprofileloded view controller so I can access the results of the selected player from the previous (this) screen
    var indexPH: IndexPath?
    
    var shouldHideButton = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = false
        navigationItem.title = "Player Profiles"
        
        searchButton.setTitle("", for: .normal)
        //custom design files must be registered inside the view controller that will use them
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    
    
    func loadMessages () {
        
        //orders the documents in the collection by a sepcified parameter, in this case "bibNumbers', the snapshot query snapshot methos returns iterates all documents inside a collection
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.bibNumber)
            .addSnapshotListener { (querySnapshot, error) in
                
                //clears the players array
                self.players = []
                
                //basic error handling from the querysnapShot method
                if let e = error {
                    print("There was an error retreiving this data from Database: \(e)")
                }
                
                
                else {
                    //querySnapshot is a class inside of Firestore that stores all relevant data. documents is one property of QS and has a method called data that returns a Dictionary
                    if let snapshotDocuments = querySnapshot?.documents {
                        //for in statement to iterate through the snapshot docs
                        for doc in snapshotDocuments {
                            //grabs the datafields of each document inside the collection
                            let dataFields = doc.data()
                            
                            let docID = doc.documentID
                            
                            if let playerName = dataFields[K.FStore.name] as? String, let bibNumber = dataFields[K.FStore.bibNumber] as? Int {
                                
                               //initializes each player object using the constants or non-optional requirements to build the object as defined in my PlayerListing struct file
                                
                                var newPlayer = PlayerListing(name: playerName, submissionId: bibNumber, documentID: docID)
                                // here I am assigning values to all optional values listed in my struct, using the datafields that are associated in the selection. Some of these fields have no value currently and will instead return a default description ("City", etc) if the datafield is nil
                                newPlayer.position = dataFields[K.FStore.positions] as? String ?? "position"
                                newPlayer.city = dataFields[K.FStore.city] as? String ?? "City"
                                newPlayer.graduatingClass = dataFields[K.FStore.classOf] as? Int
                                newPlayer.State = dataFields[K.FStore.state] as? String ?? "State"
                                newPlayer.school = dataFields[K.FStore.school] as? String ?? "School"
                                newPlayer.Vertical = dataFields[K.FStore.vertical] as? String ?? "N/A"
                                newPlayer.forty = dataFields[K.FStore.forty] as? String ?? "N/A"
                                newPlayer.benchPress = dataFields[K.FStore.benchPress] as? String ?? "N/A"
                                newPlayer.broadJump = dataFields[K.FStore.broadJump] as? String ?? "N/A"
                                newPlayer.wingSpan = dataFields[K.FStore.wingSpan] as? String ?? "N/A"
                                newPlayer.handSpan = dataFields[K.FStore.handSpan] as? String ?? "N/A"
                                newPlayer.height = dataFields[K.FStore.height] as? String ??
                                "N/A"
                                newPlayer.weight = dataFields[K.FStore.weight] as? String ?? "N/A"
                                newPlayer.shuttleRun = dataFields[K.FStore.shuttle] as? String ?? "N/A"
                                
                                
                                
                                
                                // adds each new player to the 'players' array
                                self.players.append(newPlayer)
                                
                                // a neccessary function to update a view controller when the main path is othwerise occupied (i.e. performing some big task like accessing the internet
                                DispatchQueue.main.async {
                                    // reloads the tableview if new relevant data is available in the collection
                                    self.tableView.reloadData()
                                    
                                   
                                    
                                }
                            } else {
                                
                                print("Player was not added to the array")
                    
                            }
                          
                        }
                        print("all documents finished loading")
                        
                    }
                }
            }

    }
    
    // pretty self explanatory, but this sets the contents of the searchbar, at the time the button is pressed, to a variable thats converted to an int, and then scrolls the tableview to that row of the tableview.
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        if let playerSearch =  searchBar?.text{
            
            if Int(playerSearch) ?? 0 > 0 && Int(playerSearch) ?? 0 <= players.count{
                
                self.tableView.scrollToRow(at: IndexPath(row: (Int(playerSearch) ?? 1) - 1, section: 0), at: .top, animated: false)
                
            }
            
        }
        
    }
    
    
    
    @IBAction func addPlayer(_ sender: UIButton) {
        
        //creates an alert controller that instructs the user that they're adding a new player and what that players number will be
        let addNewPlayerController = UIAlertController(title: "ADD NEW PLAYER", message: "#\(players.count+1)", preferredStyle: .alert)
        // a built in function that adds a textfield to the alertcontroller
        addNewPlayerController.addTextField{ (textField) in
            //stylization of the alercontrolelr
            textField.placeholder = "PLAYER NAME ONLY"
            addNewPlayerController.view.backgroundColor = UIColor.systemRed
            addNewPlayerController.view.tintColor = UIColor.black
        }
        
        //actions (buttons) for the alertcontroller
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "SAVE", style: .default) { _ in
            
            //what happens when the "save" action is pressed in the alert controller
            if let newEventResults = addNewPlayerController.textFields?[0].text {
                
                //adds the contents of the alertcontroller text field to the "name" datafield in firebase and assigns the bib number as 1+ the current array count
                self.db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.name: newEventResults , K.FStore.bibNumber: self.players.count+1])
                
               
                //scrolls to the bottom of the list
                self.tableView.scrollToRow(at: IndexPath(row: self.players.count - 1 , section: 0), at: .top, animated: false)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else {
                print("Houston... you know the rest")
            }
        }
        //very important and I forget this sometimes, but you have to actually add the actions to the alertcontroller after creating them using .addAction(action) ANNND present it
        addNewPlayerController.addAction(saveAction)
        addNewPlayerController.addAction(cancelAction)
        self.present(addNewPlayerController, animated: false)
    }
    
    @objc func takePhoto(_ sender: UIButton) {
        // creates a variable that references the tag we appended to "takePhoto" in cellForRowAt
        let row = sender.tag
        //changes the value of the global variable to the tag
        rowPH = row
        //checks to see if the camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //initializes the imagepicker
            imagePicker = UIImagePickerController()
            //sets the delegate for the picker to itself?? didn't know this was a thing. TY Stackoverflow
            imagePicker?.delegate = self
            //sets the sourcetype for the imagePicker
            imagePicker?.sourceType = .camera
            //presents the camera
            present(imagePicker!, animated: true, completion: nil)
            
        }
       
    }
    
    //a delegate/protocol method? once again, not something i wholly understand, but this method is called automatically once the imagepicker has made a selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // assigns the original image of the selection to a variable and downcasts it as an UIImage
        selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //dismisses it when complete
        dismiss(animated: true, completion: nil)
        
        //compresses the quality of the image for performance
        if selectedPhoto.jpegData(compressionQuality: 0.8) != nil{
            
            // Call function to upload photo to Firebase Storage
            updatePicture(photo: selectedPhoto)
        }
    }
    
    
    
    func updatePicture(photo: UIImage){
        
        
        //creates  reference to the specific players headshot file name (used name and submission ID to make each one unique and easy to find, this actually ended up being an L for me, but whatever
        let playersRef = storageRef.child("\(players[rowPH ?? 0].submissionId), \(players[rowPH ?? 0].name).jpg")
        
        //creates the folder that holds all headshots  ".child('foldername'/'filename') and some extra but w/e
        let headShotRef = storageRef.child("Headshots/\(playersRef)")
        
        if let imageData = photo.jpegData(compressionQuality: 0.5){
            
            _ = headShotRef.putData(imageData) { metadata, error in
                
                if error == nil && metadata != nil{
                
                    
                    headShotRef.downloadURL { url, error in
                        
                        guard url != nil
                                
                        else{
                            
                            let e = error
                            print(e?.localizedDescription ?? "Something went wrong with the upload process")
                            return
                            
                        }
                    }
                }
                
                
            }} else { print("photo.jpegData is nil")}
    }
    
    
    func assignURLToPlayersFromFirebaseStorage(indexPaths: [IndexPath]) {
        
        // Loop through all visible players and update their photos from Firebase Storage
        for indexPath in indexPaths {

            
            //the following two lines are redundant, but not identical.basically i ended up duplicating part of the path name by mistake, but since I already uploaded some pictures, I decided to recreate the mistake here so that those existing (redundant) path names could be viewed.
            let playersRef = storageRef.child("\(players[indexPath.row ].submissionId), \(players[indexPath.row ].name).jpg")
            
            //creates the folder that holds all headshots  ".child('foldername'/'filename')
            let photoRef = storageRef.child("Headshots/\(playersRef)")
            
            //keeping this print statment as a reminder to double double check the url names because this is what i've been stuck on all day, and this print statement helped me find the answer
            //print(storageRef)
           
            // Get the download URL for the photo from Firebase Storage
            photoRef.downloadURL { url, error in
                if let headShotURL = url {
                    // Update the player's photo URL in the players array
                    self.players[indexPath.row].url = headShotURL
                   
                } else if let error = error {
                   print("Error getting download URL: \(error.localizedDescription)")
                }
            }
        }
        
    }
}

extension PlayerProfileController: UITableViewDataSource {
    // defines the number of rows in the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    
    
    //defines the cells of the (visible)tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //assigns the cell as the XIB File
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for:indexPath) as! PlayerCell
        
        if shouldHideButton {
            cell.addPhoto.isHidden = true
        }
        cell.addPhoto.setTitle("", for: .normal)
        cell.playername.text = players[indexPath.row].name
        cell.graduatingClass.text = "\(players[indexPath.row].graduatingClass ?? 0000)"
        cell.position.text = players[indexPath.row].position ?? "Position"
        cell.playerschool.text = players[indexPath.row].school ?? "School"
        cell.playerlocation.text = "\(players[indexPath.row].city ?? "City"),\(players[indexPath.row].State ?? "State")"
        cell.numberonChest.text = String(players[indexPath.row].submissionId)
        cell.addPhoto.tag = indexPath.row
        // really cool and useful, I was able to assign the function of a button that exists inside another view controller (PlayerCell) by using @objc and #selecter to set the target of that button to a funciton in this VC
        cell.addPhoto.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        // uses tableView.indexPathsForVisibleRows to pass the visible indexpaths into my assignURLToPlayersFromFirebaseStorage function
        
        if let imageUrl = players[indexPath.row].url {
            cell.playerSnapshot.sd_setImage(
                with: imageUrl,
                placeholderImage: UIImage(named: "MCS Logo no BG"),
                options: [.scaleDownLargeImages],
                completed: { [weak self] image, _, _, _ in
                    guard let self = self else { return }
                    if let image = image {
                        let resizedImage = image.sd_resizedImage(
                            with: CGSize(width: 200, height: 200),
                            scaleMode: .aspectFill
                        )
                        cell.playerSnapshot.image = resizedImage
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            )
        } else {
            cell.playerSnapshot.image = UIImage(named: "MCS Logo no BG")
        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        let visibleRows = visibleIndexPaths.map { $0.row }
        
        if visibleRows.contains(indexPath.row) {
            assignURLToPlayersFromFirebaseStorage(indexPaths: visibleIndexPaths)
        }
    }
}
        
        extension PlayerProfileController: UITableViewDelegate, UITextFieldDelegate {
        //the did select row at method, in this case, once a cell is selected it takes you to the full athletic profile page
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
                indexPH = indexPath
                
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                // activates the established seguew to the profile page
                self.performSegue(withIdentifier: "ViewToProfilePage", sender: self)
    }
            // prepares the destination VC with the neccesary information we need to populate the page, in this case, the index path, and a reference to the players array
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
                if segue.identifier == "ViewToProfilePage"{
                    
                    let destinationVC = segue.destination as! PlayerProfileLoaded
                    destinationVC.navigationItem.title = "Player Results"
                    
                    destinationVC.indexPath = indexPH?.row
                    
                    destinationVC.playerArray = players
                    
                    
                }
            }
            
            
            //this literally just allows the "return" button to act as "enter" and perform the same function as the search button
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
                if let playerSearch =  searchBar?.text {
                    
                    if Int(playerSearch) ?? 0 > 0 && Int(playerSearch) ?? 0 <= players.count {
                        
                        self.tableView.scrollToRow(at: IndexPath(row: (Int(playerSearch) ?? 1) - 1, section: 0), at: .top, animated: false)
                        
                        searchBar.endEditing(true)}}
                    return true
                }
            
        }
            
