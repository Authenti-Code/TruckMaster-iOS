//
//  PulsingMarkerView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 30/06/26.
//

import UIKit

final class PulsingMarkerView: UIView {

    private let profileImageView = UIImageView()
    private let pulseLayer = CAShapeLayer()

    init(profileImage: UIImage?, size: CGFloat = 160) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        backgroundColor = .clear
        setupPulse(size: size)
        setupProfileImage(image: profileImage, size: size)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupPulse(size: CGFloat) {
        pulseLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)

        let path = UIBezierPath(ovalIn: CGRect(x: size * 0.25, y: size * 0.25,
                                                width: size * 0.5, height: size * 0.5))
        pulseLayer.path = path.cgPath
        pulseLayer.fillColor = UIColor.systemBlue.withAlphaComponent(0.35).cgColor
        pulseLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pulseLayer.position = CGPoint(x: pulseLayer.frame.midX, y: pulseLayer.frame.midY)

        layer.addSublayer(pulseLayer)
        startPulseAnimation()
    }

    private func startPulseAnimation() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 1.6

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.6
        opacity.toValue = 0.0

        let group = CAAnimationGroup()
        group.animations = [scale, opacity]
        group.duration = 1.6
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)

        pulseLayer.add(group, forKey: "pulse")
    }

    private func setupProfileImage(image: UIImage?, size: CGFloat) {
        let diameter = size * 0.32
        profileImageView.frame = CGRect(x: (size - diameter) / 2,
                                         y: (size - diameter) / 2,
                                         width: diameter, height: diameter)
        profileImageView.image = image ?? UIImage(named: ImageConstants.user)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = diameter / 2
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
        addSubview(profileImageView)
    }
}
