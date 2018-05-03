

import UIKit

private let reuseIdentifier = "imageCell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout{
    

    var test = 1
    
    @IBOutlet var imageCollectionView: UICollectionView!
    
    var imageFetcher: ImageFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        imageCollectionView.dropDelegate = self
        imageCollectionView.dragDelegate = self
        imageCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchCells(byHandlingRecognizer:))))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableVC?.model.galleries[currentGallery] = images // making sure changes to images reflected in galleries
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    


    // MARK: pinch Gesture
    
    var collectionViewScale = CGFloat(1)
    
//    lazy var pinchGesture = UIPinchGestureRecognizer(target: imageCollectionView, action: #selector(pinchCollectionView))
    
    @objc func pinchCells(byHandlingRecognizer recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended: collectionViewScale *= recognizer.scale
        recognizer.scale = 1.0
        imageCollectionView.collectionViewLayout.invalidateLayout()
        //case .ended:
        default: break
        }
    }

    
//    @objc func pinchCollectionView(){
//        switch pinchGesture.state {
//        case .changed,.ended: collectionViewScale *= pinchGesture.scale
//            pinchGesture.scale = 1.0
//        default: break
//        }
//    }



    
    
    // MARK: Collection view data source

    
    lazy var tableVC: ImageSelectorTableViewController? = self.splitViewController?.viewControllers[0].childViewControllers[0] as? ImageSelectorTableViewController
    
    var currentGallery = "First Gallery"

    
    
    var images: [UIImage] = []
    
    private func updateParentVCModel(){
        self.tableVC?.model.galleries[currentGallery] = self.images
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    //only called if there are items (cells) to layout, not if model is empty
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell {
            let image = images[indexPath.item]
            cell.imageView.image = image
            cell.spinner?.stopAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            return cell
        }
    }
    
    func setGallery(to galleryName: String) { // creates a new model w/ name give from table view controller
        currentGallery = galleryName
    }
    
    // MARK: Drop Delegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            let proposal = UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            return proposal
        } else {
            let proposal = UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            return proposal
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndex = coordinator.destinationIndexPath ?? IndexPath(item: 0, section:0)
        for item in coordinator.items {
            
            if let sourceIndexPath = item.sourceIndexPath { // from w/in collection view, already have images
                let image: UIImage! = (item.dragItem.localObject as? UIImage) ?? UIImage(named: "questionMark")
                collectionView.performBatchUpdates({
                    images.remove(at: sourceIndexPath.item)
                    images.insert(image, at: destinationIndex.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndex])
                })
                updateParentVCModel()

            } else { // from outside of view, need to load images
                _ = item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (nsurl,error) in
                    DispatchQueue.global(qos: .userInitiated).async {
                        let url = ( (nsurl as? NSURL) ?? NSURL() ) as URL
                        let dataTry = try? Data(contentsOf: url)
                        let image: UIImage!
                        if let data = dataTry {
                            image = UIImage(data: data) ?? UIImage(named: "questionMark")
                        } else {
                            image = UIImage(named: "questionMark")
                        }
                        DispatchQueue.main.async {
                            collectionView.performBatchUpdates({ [weak self] in
                                self?.images.insert(image, at: destinationIndex.item)
                                collectionView.insertItems(at: [destinationIndex])
                                self?.updateParentVCModel()
                            })
                        }
                    }
                })
                
            }
        }
    }
    
    
    // MARK: Drag delegate methods
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let image = images[indexPath.item]
        let item = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: item)
 
        dragItem.localObject = image
        return [dragItem]
    }
    
    
    // MARK: Drag flow layout
    
    private let multiplier = CGFloat(100)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.item]
        let width = image.size.width
        let normalizedHeight = image.size.height / width
        let normalizedWidth = CGFloat(1)
        
        //let cell = imageCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        //cell?.adjustScale(scaleBy: collectionViewScale)

        return CGSize(width: normalizedWidth * multiplier * collectionViewScale, height: normalizedHeight * multiplier * collectionViewScale)
    }
    
    
     // MARK: - Navigation
     
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "showImageModal" {
            if let destination = segue.destination as? DisplayImageViewController {
                if let imageCell = sender as? ImageCollectionViewCell {
                    if let imageFromCell = imageCell.imageView.image {
                        destination.image = imageFromCell
                    }
                }
            }
        }
        
        
     }
 
    
    // MARK: UICollectionViewDataSource
    //
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
