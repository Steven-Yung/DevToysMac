//
//  Color.swift
//  DevToys
//
//  Created by yuki on 2022/02/19.
//

import CoreUtil

struct Color: Codable {
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat
    
    var rgb: (CGFloat, CGFloat, CGFloat) {
        let nsColor = self.nsColor
        return (nsColor.redComponent, nsColor.greenComponent, nsColor.blueComponent)
    }
    var cmyk: (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black:CGFloat) {
        let (r, g, b) = self.rgb

        let k = 1.0 - max(r, g, b)
        var c = (1.0-r-k) / (1.0-k)
        var m = (1.0-g-k) / (1.0-k)
        var y = (1.0-b-k) / (1.0-k)

        if c.isNaN { c = 0.0 }
        if m.isNaN { m = 0.0 }
        if y.isNaN { y = 0.0 }

        return (cyan: c, magenta: m, yellow: y, black: k)
    }
    
    init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    init(nsColor: NSColor) {
        self.init(hue: nsColor.hueComponent, saturation: nsColor.saturationComponent, brightness: nsColor.brightnessComponent, alpha: nsColor.alphaComponent)
    }
    init?(hex3: String, alpha: CGFloat) {
        if hex3.isEmpty { return nil }
        guard hex3.count == 3 else { NSSound.beep(); return nil }
        let scanner = Scanner(string: hex3)
        var components: UInt64 = 0
        guard scanner.scanHexInt64(&components) else { NSSound.beep(); return nil }
        let r = CGFloat((components & 0xF00) >> 8) / 255.0 
        let g = CGFloat((components & 0x0F0) >> 4) / 255.0
        let b = CGFloat((components & 0x00F) >> 0) / 255.0
        
        self.init(nsColor: NSColor(red: 17 * r, green: 17 * g, blue: 17 * b, alpha: alpha))
    }
    
    
    init?(hex6: String, alpha: CGFloat) {
        guard hex6.count == 6 else { NSSound.beep(); return nil }
        let scanner = Scanner(string: hex6)
        var components: UInt64 = 0
        guard scanner.scanHexInt64(&components) else { NSSound.beep(); return nil }
        let r = CGFloat((components & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((components & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((components & 0x0000FF) >> 0) / 255.0
        
        self.init(nsColor: NSColor(red: r, green: g, blue: b, alpha: alpha))
    }
    init?(hex8: String) {
        guard hex8.count == 8 else { NSSound.beep(); return nil }
        let scanner = Scanner(string: hex8)
        var components: UInt64 = 0
        guard scanner.scanHexInt64(&components) else { NSSound.beep(); return nil }
        let r = CGFloat((components & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((components & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((components & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat((components & 0x000000FF) >> 0) / 255.0
        
        self.init(nsColor: NSColor(red: r, green: g, blue: b, alpha: a))
    }
    
    var nsColor: NSColor { NSColor(colorSpace: .current, hue: hue, saturation: saturation, brightness: brightness, alpha: alpha) }
    var cgColor: CGColor { nsColor.cgColor }
    
    func withRed(_ value: CGFloat) -> Color {
        Color(nsColor: NSColor(red: value.clamped(0...1), green: nsColor.greenComponent, blue: nsColor.blueComponent, alpha: alpha))
    }
    func withGreen(_ value: CGFloat) -> Color {
        Color(nsColor: NSColor(red: nsColor.redComponent, green: value.clamped(0...1), blue: nsColor.blueComponent, alpha: alpha))
    }
    func withBlue(_ value: CGFloat) -> Color {
        Color(nsColor: NSColor(red: nsColor.redComponent, green: nsColor.greenComponent, blue: value.clamped(0...1), alpha: alpha))
    }
    func withSB(_ saturation: CGFloat, _ brightness: CGFloat) -> Color {
        Color(hue: hue, saturation: saturation.clamped(0...1), brightness: brightness.clamped(0...1), alpha: alpha)
    }
    
}


extension Color {
    static let `default` = Color(hue: 0, saturation: 1, brightness: 1, alpha: 1)
}
