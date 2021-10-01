//
//  MessageLocationCell.swift
//  VVIP_chat
//
//  Created by mac on 13/08/21.
//

import UIKit
import MapKit

class MessageLocationCell: UITableViewCell {
    weak var delegate:ChatViewControllerDelegate?
    var location: Location!
    
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageLocationView: MKMapView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    var trailingConstraint : NSLayoutConstraint!
    var leadingConstrint : NSLayoutConstraint!
    var chatGray = UIColor(red: 69/255.0, green: 90/255.0, blue: 100/255.0, alpha: 1)
    var chatGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLocationView.showsUserLocation = false
        time.text = nil
//        checkMark.image = nil
        leadingConstrint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLocationView!.isUserInteractionEnabled = true
        messageLocationView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationTapped(_:))))
    }
    
    private func locationConfig(location: Location){
        messageLocationView.mapType = .hybrid
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        annotation.coordinate = coordinate
        messageLocationView.addAnnotation(annotation)
        //        messageLocationView.isScrollEnabled = true
        //        messageLocationView.isZoomEnabled = true
        //        messageLocationView.showsCompass = true;
        //        messageLocationView.showsUserLocation = true
//        let cor: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees()), latitudinalMeters: 500, longitudinalMeters: 500)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        messageLocationView.setRegion(region, animated: true)
    }
    
    @objc func locationTapped(_ sender: UITapGestureRecognizer) {
        print("location tapped")
//        let region: MKCoordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let city = location.publisher
        print(city)
        mapItem.name = "\(String(describing: location.latitude)),\(String(describing: location.longitude))"
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        print("selected: \(selected)")
        // Configure the view for the selected state
        if(selected){
            contentView.backgroundColor = #colorLiteral(red: 0.1072840765, green: 0.1896482706, blue: 0.3115866184, alpha: 1).withAlphaComponent(0.8)
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    func updateMessageCell(by message: MessageData){
        messageBackgroundView.layer.cornerRadius = 10
        
        messageBackgroundView.clipsToBounds = true
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstrint = messageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        location = message.location
        locationConfig(location: message.location!)
        self.time.text = message.time
        
        if(message.isFirstUser){
            messageBackgroundView.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
            trailingConstraint.isActive = true
            checkMark.isHidden = false
            time.textColor = .black
        } else {
            messageBackgroundView.backgroundColor = chatGray
            leadingConstrint.isActive = true
            checkMark.isHidden = true
            time.textColor = .white
        }
    }
    
}
