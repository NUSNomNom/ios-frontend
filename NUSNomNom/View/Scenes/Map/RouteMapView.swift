//
//  RouteMapView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 26/6/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct RouteMapView: UIViewRepresentable {
    let destination: CLLocationCoordinate2D
    let onStepsReady: ([String]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(destination: destination, onStepsReady: onStepsReady)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    class Coordinator: NSObject, MKMapViewDelegate {
        let destination: CLLocationCoordinate2D
        let onStepsReady: ([String]) -> Void
        weak var mapView: MKMapView?

        init(destination: CLLocationCoordinate2D, onStepsReady: @escaping ([String]) -> Void) {
            self.destination = destination
            self.onStepsReady = onStepsReady
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            getRoute(from: userLocation.coordinate, to: destination, on: mapView)
        }

        func getRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, on mapView: MKMapView) {
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .walking

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }

                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40),
                    animated: true
                )

                let annotation = MKPointAnnotation()
                annotation.coordinate = destination
                annotation.title = "Store"
                mapView.addAnnotation(annotation)

                let steps = route.steps
                    .map { $0.instructions }
                    .filter { !$0.isEmpty && !$0.lowercased().starts(with: "start on") }
                self.onStepsReady(steps)
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            let identifier = "StorePin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.glyphImage = UIImage(systemName: "fork.knife")
                annotationView?.markerTintColor = .systemOrange
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}

