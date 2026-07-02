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
                            CallingCardContent(phoneNumber: "1234567867")

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
            
          
            HStack{
                Image(ImageConstants.line1)
                  
                VStack{
                    VStack(alignment: .leading, spacing: 2) {
                        Text("From")
                            .font(.custom("Livvic-Medium", size: 14))
                            .foregroundColor(AppColors.grey1)
                        Text("from address")
                            .font(.custom("Livvic-Medium", size: 14))
                            .foregroundColor(AppColors.textBlack1)
                    }
                    .padding(.bottom, 6)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Shipping to")
                            .font(.custom("Livvic-Regular", size: 13))
                            .foregroundColor(AppColors.grey1)
                        Text("drop address")
                            .font(.custom("Livvic-Medium", size: 14))
                            .foregroundColor(AppColors.textBlack1)
                    }
                }
            }
            .padding(.bottom, 10)
            
            HStack{
                ReusableText(
                    title: LocalizedStringKey("Estimated time:"),
                    fontSize: 13,
                    fontName: "Livvic-Medium",
                    fontColor: AppColors.grey1
                )
                
                ReusableText(
                    title: LocalizedStringKey("15 min"),
                    fontSize: 13,
                    fontName: "Livvic-Medium",
                    fontColor: AppColors.colorYellow
                )
                
            }
        
        }
        .padding(16)
        .background(AppColors.colorBlue1)
        .clipShape(RoundedCorner(radius: 12, corners: .allCorners))
    }
}

@available(iOS 16.0, *)
private struct CallingCardContent: View {
    let phoneNumber: String

    @State private var dragOffset: CGFloat = 0
    @State private var isCallTriggered = false

    private let trackWidth: CGFloat = 300
    private let buttonSize: CGFloat = 60
    private var maxDragDistance: CGFloat {
        trackWidth - buttonSize - 8
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 10) {
                Image(ImageConstants.user)
                    .resizable()
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 2) {
                    ReusableText(
                        title: LocalizedStringKey("Mr. Driver"),
                        fontSize: 15,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    ReusableText(
                        title: LocalizedStringKey("Driver"),
                        fontSize: 12,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.grey1
                    )
                }
                Spacer()

                Image(ImageConstants.calling)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .offset(x: dragOffset)
                    .scaleEffect(isCallTriggered ? 1.1 : 1.0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                guard !isCallTriggered else { return }
                                let translation = value.translation.width
                                let clamped = min(0, max(translation, -maxDragDistance))
                                dragOffset = clamped
                            }
                            .onEnded { value in
                                guard !isCallTriggered else { return }
                                if abs(dragOffset) >= maxDragDistance * 0.85 {
                                    triggerCall()
                                } else {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: dragOffset)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 5)
        }
        .background(AppColors.colorPink)
        .clipShape(RoundedCorner(radius: 50, corners: .allCorners))
    }

    private func triggerCall() {
        isCallTriggered = true

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            dragOffset = -maxDragDistance
        }

        callThroughDialer(phoneNumber)

        // Reset after a short delay so it's ready for another swipe if the user returns to the app
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                dragOffset = 0
            }
            isCallTriggered = false
        }
    }

    private func callThroughDialer(_ number: String) {
        let sanitized = number.filter { $0.isNumber || $0 == "+" }
        guard let url = URL(string: "tel://\(sanitized)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
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
