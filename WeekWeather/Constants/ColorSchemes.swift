//
//  ColorSchemes.swift
//  WeekWeather
//
//  Created by Egor on 23/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

protocol SchemeOpacityProtocol {
    var backgroundListImg: Float { get }
    var backgroundImg: Float { get }
    var weatherIcon: Float { get }
    var cellIcon: Float { get }
}

protocol SchemeImagesProtocol {
    var backgroundListImg: UIImage { get }
    var backgroundExtInfoImg: UIImage { get }
}

protocol SchemeProtocol {
    var image: SchemeImagesProtocol { get }
    var opasity: SchemeOpacityProtocol { get }
    var color: SchemeColorProtocol { get }
}

protocol SchemeColorProtocol {
    var cellTitlesColor: UIColor { get }
    var commonSubstrate: UIColor { get }
    var bottomStackBg: UIColor { get }
    var preasureHumidityBg: UIColor { get }
    var sunriseSunsetBg: UIColor { get }
    var backItem: UIColor  { get }
    var firstCellBgColor: UIColor { get }
    var cellBgColor: UIColor { get }
    var listTitleColor: UIColor { get }
    var extendInfoTitleColor: UIColor { get }
    var cellImageTintColor: UIColor { get }
    var listViewColor: UIColor { get }
    var viewColor: UIColor { get }
    var tempLabel: UIColor { get }
    var descrLabel: UIColor { get }
    var humidityIcon: UIColor { get }
    var humidityLabel: UIColor { get }
    var preasureIcon: UIColor { get }
    var preasureLabel: UIColor { get }
    var sunriseIcon: UIColor { get }
    var sunriseLabel: UIColor { get }
    var sunsetIcon: UIColor { get }
    var sunsetLabel: UIColor { get }
    var mornTemp: UIColor { get }
    var mornIcon: UIColor { get }
    var mornDescr: UIColor { get }
    var dayTemp: UIColor { get }
    var dayIcon: UIColor { get }
    var dayDescr: UIColor { get }
    var eveTemp: UIColor { get }
    var eveIcon: UIColor { get }
    var eveDescr: UIColor { get }
    var nightTemp: UIColor { get }
    var nightIcon: UIColor { get }
    var nightDescr: UIColor { get }
}

struct ColorSchemes {
    
    struct Day: SchemeProtocol {
        
        var color: SchemeColorProtocol {
            return Color()
        }
        
        var image: SchemeImagesProtocol {
            return Image()
        }
        
        var opasity: SchemeOpacityProtocol {
            return Opacity()
        }
        
        struct Image: SchemeImagesProtocol {
            let backgroundListImg = UIImage(imageLiteralResourceName: "clouds")
            let backgroundExtInfoImg = UIImage(imageLiteralResourceName: "clouds")
        }
        
        struct Color: SchemeColorProtocol {
            let cellTitlesColor: UIColor = .darkGray
            let commonSubstrate: UIColor = #colorLiteral(red: 0.768627451, green: 0.8509803922, blue: 0.9764705882, alpha: 0.5003210616)
            let bottomStackBg: UIColor = #colorLiteral(red: 0.6823529412, green: 0.8078431373, blue: 0.9764705882, alpha: 0.2386290668)
            let preasureHumidityBg: UIColor = #colorLiteral(red: 0.768627451, green: 0.8509803922, blue: 0.9764705882, alpha: 0.5)
            let sunriseSunsetBg: UIColor = #colorLiteral(red: 0.6823529412, green: 0.8078431373, blue: 0.9764705882, alpha: 0.2379869434)
            let backItem: UIColor = .systemBlue
            let firstCellBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let cellBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let listTitleColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            let extendInfoTitleColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            let cellImageTintColor = #colorLiteral(red: 0.5803921569, green: 0.7921568627, blue: 1, alpha: 1)
            let listViewColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let viewColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let tempLabel: UIColor = .darkGray
            let descrLabel: UIColor = .darkGray
            let humidityIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let humidityLabel: UIColor = .darkGray
            let preasureIcon: UIColor = .gray
            let preasureLabel: UIColor = .darkGray
            let sunriseIcon: UIColor = #colorLiteral(red: 1, green: 0.7921568627, blue: 0.3294117647, alpha: 1)
            let sunriseLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let sunsetIcon: UIColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0.4196078431, alpha: 1)
            let sunsetLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let mornTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0, alpha: 1)
            let mornIcon: UIColor = #colorLiteral(red: 1, green: 0.7921568627, blue: 0.3294117647, alpha: 1)
            let mornDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let dayTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.3607843137, blue: 0, alpha: 1)
            let dayIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.7441673801)
            let dayDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let eveTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0, alpha: 1)
            let eveIcon: UIColor = #colorLiteral(red: 1, green: 0.6039215686, blue: 0.5843137255, alpha: 1)
            let eveDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let nightTemp: UIColor = #colorLiteral(red: 0, green: 0.2352941176, blue: 0.4980392157, alpha: 1)
            let nightIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let nightDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        }
        
        struct Opacity: SchemeOpacityProtocol {
            let backgroundListImg: Float = 0.05
            let backgroundImg: Float = 0.3
            let weatherIcon: Float = 0.95
            let cellIcon: Float = 1.0
        }
        
    }
    
    struct Morning {
        let backgroundImage = UIImage(imageLiteralResourceName: "cloudsMorning")
        
    }
    
    struct Evening {
        
        struct Image {
            let backgroundImg = UIImage(imageLiteralResourceName: "clouds")
            let backgroundExtInfoImg = UIImage(imageLiteralResourceName: "cloudsEvening")
        }
        
        struct Color {
            let viewColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let tempLabel: UIColor = .darkGray
            let descrLabel: UIColor = .darkGray
            let humidityIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let humidityLabel: UIColor = .darkGray
            let preasureIcon: UIColor = .gray
            let preasureLabel: UIColor = .darkGray
            let sunriseIcon: UIColor = #colorLiteral(red: 1, green: 0.7834197891, blue: 0, alpha: 0.6987639127)
            let sunriseLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let sunsetIcon: UIColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 0.6951519692)
            let sunsetLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let mornTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0, alpha: 1)
            let mornIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.5)
            let mornDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let dayTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.3607843137, blue: 0, alpha: 1)
            let dayIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.7441673801)
            let dayDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let eveTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0, alpha: 1)
            let eveIcon: UIColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 0.5241063784)
            let eveDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let nightTemp: UIColor = #colorLiteral(red: 0, green: 0.2352941176, blue: 0.4980392157, alpha: 1)
            let nightIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let nightDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        }
        
        struct Opacity {
            let backgroundImg = 0.9
            let weatherIcon = 0.85
        }
        
    }
    
    struct Night: SchemeProtocol {
        
        var color: SchemeColorProtocol {
            return Color()
        }
        
        var image: SchemeImagesProtocol {
            return Image()
        }
        
        var opasity: SchemeOpacityProtocol {
            return Opacity()
        }
        
        struct Image: SchemeImagesProtocol {
            let backgroundListImg = UIImage(imageLiteralResourceName: "cloudsStarsNight")
            let backgroundExtInfoImg = UIImage(imageLiteralResourceName: "cloudsStarsNight")
            //let backgroundImg2 = UIImage(imageLiteralResourceName: "stars")
        }
        
        struct Color: SchemeColorProtocol {
            let cellTitlesColor: UIColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9450980392, alpha: 1)
            let commonSubstrate: UIColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.2444884417)
            let bottomStackBg: UIColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.2444884417)
            let preasureHumidityBg: UIColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.2444884417)
            let sunriseSunsetBg: UIColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.2444884417)
            let backItem: UIColor = .white
            let firstCellBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let cellBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let listTitleColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9450980392, alpha: 1)
            let extendInfoTitleColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9450980392, alpha: 1)
            let cellImageTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235)
            let listViewColor: UIColor = #colorLiteral(red: 0.3215601488, green: 0.3463254821, blue: 0.4152522208, alpha: 1)
            let viewColor: UIColor = .darkGray
            let tempLabel: UIColor = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9450980392, alpha: 1)
            let descrLabel: UIColor = .white
            let humidityIcon: UIColor = #colorLiteral(red: 0.5803921569, green: 0.7921568627, blue: 1, alpha: 1)
            let humidityLabel: UIColor = .white
            let preasureIcon: UIColor = .opaqueSeparator
            let preasureLabel: UIColor = .white
            let sunriseIcon: UIColor = #colorLiteral(red: 1, green: 0.8235294118, blue: 0.1843137255, alpha: 0.8000856165)
            let sunriseLabel: UIColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.7764705882, alpha: 1)
            let sunsetIcon: UIColor = #colorLiteral(red: 1, green: 0.537254902, blue: 0.2039215686, alpha: 0.9040560788)
            let sunsetLabel: UIColor = #colorLiteral(red: 1, green: 0.9098039216, blue: 0.9254901961, alpha: 1)
            let mornTemp: UIColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.7803921569, alpha: 1)
            let mornIcon: UIColor = #colorLiteral(red: 1, green: 0.8549019608, blue: 0.2588235294, alpha: 0.8)
            let mornDescr: UIColor = #colorLiteral(red: 0.9327142923, green: 0.9359927306, blue: 0.9458280457, alpha: 1)
            let dayTemp: UIColor = #colorLiteral(red: 1, green: 0.9877448877, blue: 0.7642853387, alpha: 1)
            let dayIcon: UIColor = #colorLiteral(red: 1, green: 0.9229307487, blue: 0, alpha: 0.7012521404)
            let dayDescr: UIColor = #colorLiteral(red: 0.9327142923, green: 0.9359927306, blue: 0.9458280457, alpha: 1)
            let eveTemp: UIColor = #colorLiteral(red: 1, green: 0.9034539783, blue: 0.9037099723, alpha: 1)
            let eveIcon: UIColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 0.5971746576)
            let eveDescr: UIColor = #colorLiteral(red: 0.9327142923, green: 0.9359927306, blue: 0.9458280457, alpha: 1)
            let nightTemp: UIColor = #colorLiteral(red: 0.9035780239, green: 0.9391689358, blue: 1, alpha: 1)
            let nightIcon: UIColor = #colorLiteral(red: 0.5960784314, green: 0.7882352941, blue: 1, alpha: 1)
            let nightDescr: UIColor = #colorLiteral(red: 0.9327142923, green: 0.9359927306, blue: 0.9458280457, alpha: 1)
        }
        
        struct Opacity: SchemeOpacityProtocol {
            let backgroundListImg: Float = 0.15
            let backgroundImg: Float = 0.9
            let weatherIcon: Float = 0.85
            let cellIcon: Float = 0.8
        }
    }
}
