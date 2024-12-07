//
//  MapAnnotationDelegate.swift
// Repurposed from: App14  created by Sakib Miazi on 6/14/23.
// pilly
//  Repurposed from: https://www.hackingwithswift.com/read/16/3/annotations-and-accessory-views-mkpinannotationview



import Foundation
import MapKit

extension PharmacyViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
        guard let annotation = annotation as? Place else { return nil }
        
        var view:MKMarkerAnnotationView
        
        if let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: Configs.placeIdentifier) as? MKMarkerAnnotationView{
            annotationView.annotation = annotation
            view = annotationView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Configs.placeIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place,
              let mapItem = annotation.mapItem else { return }
        
        showPharmacyOptions(for: mapItem)
    }
}
