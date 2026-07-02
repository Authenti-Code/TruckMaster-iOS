//
//  MapTrackView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 02/07/26.
//
internal import SwiftUI
import GoogleMaps

@available(iOS 16.0, *)
struct MapTrackView: View {
    @ObservedObject var viewModel: MapTrackViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack {

                MapTrackLocationView(
                    coordinate: viewModel.state.pickUpCoordinate,
                    markerImg: viewModel.state.markerImg
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack(spacing: 12) {
                        Button { viewModel.backTapped() } label: {
                            Image(ImageConstants.backImage)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 12)

                    Spacer()

                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            DetailCardContent()
                            CallingCardContent()

                        }
                        .padding(.horizontal, 20)
                        
                    }
                    .padding(.top, 24)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                    .background(Color.white)
                    .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                    .overlay(
                        RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
            }
            .ignoresSafeArea(edges: .top)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
    }
}



@available(iOS 16.0, *)
private struct DetailCardContent: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 10) {
                Image(ImageConstants.truckImage1)

                VStack(alignment: .leading, spacing: 2) {
                    ReusableText(
                        title: LocalizedStringKey("Pickup Truck"),
                        fontSize: 15,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    ReusableText(
                        title: LocalizedStringKey("Tracking ID: 12345678"),
                        fontSize: 12,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.grey1
                    )
                }
            }
            .padding(.bottom, 12)

            Divider()
                .padding(.bottom, 12)
        }
        .padding(16)
        .background(AppColors.colorBlue1)
        .clipShape(RoundedCorner(radius: 12, corners: .allCorners))
    }
}

@available(iOS 16.0, *)
private struct CallingCardContent: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 10) {
                Image(ImageConstants.user)
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 2) {
                    ReusableText(
                        title: LocalizedStringKey("Pickup Truck"),
                        fontSize: 15,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    ReusableText(
                        title: LocalizedStringKey("Tracking ID: 12345678"),
                        fontSize: 12,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.grey1
                    )
                }
                Spacer()
                HStack{
                    Image(ImageConstants.calling)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .swipeActions {
                            Button("Burn") {
                                print("Right on!")
                            }
                            .tint(.red)
                        }
                    
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 5)
        }
        .background(AppColors.colorPink)
        .clipShape(RoundedCorner(radius: 50, corners: .allCorners))
    }
}


private struct MapTrackLocationView : UIViewRepresentable {

    let coordinate: CLLocationCoordinate2D
    let markerImg: UIImage?

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = false

        let marker = GMSMarker(position: coordinate)
        marker.iconView = UIImageView(image: markerImg)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
    
}

#Preview {
    return MapTrackLocationView(coordinate: .init(latitude: 37.7749, longitude: -122.4194), markerImg: nil)
}
