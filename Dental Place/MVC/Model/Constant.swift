//
//  Constant.swift
//  Moocher
//
//  Created by administrator on 05/07/19.
//  Copyright © 2019 administrator. All rights reserved.
//

import Foundation
import UIKit


//<?xml version="1.0" encoding="utf-8"?>
//<resources>
//<color name="colorPrimary">#AC38D7</color>
//<color name="colorPrimaryDark">#CD4992</color>
//<color name="colorAccent">#F05C49</color>
//<color name="colorPrimaryRed">#53B840</color>
//<color name="colorPrimaryDarkRed">#A213C2</color>
//<color name="colorAccentRed">#FF6E40</color>
//<color name="colorBackGroundWhite">#FFFFFF</color>
//
//<color name="text_color_white">#FFFFFF</color>
//<color name="text_color_light_brown">#EE7953</color>
//<color name="text_color_orange">#FF6E40</color>
//<color name="text_color_blue">#6394F7</color>
//<color name="text_color_black">#000000</color>
//<color name="text_color_light_black">#535353</color>
//<color name="text_color_maroon">#4D0E0E</color>
//
//<color name="text_color_light_pink">#CD4992</color>
//<color name="light_green">#1C9492</color>
//<color name="view_line">#A7ADB2</color>
//<color name="white">#FFFFFF</color>
//<array name="array_dot_active">
//<item>@color/colorAccentRed</item>
//<item>@color/colorAccentRed</item>
//<item>@color/colorAccentRed</item>
//<item>@color/colorAccentRed</item>
//</array>
//<array name="array_dot_inactive">
//<item>@color/view_line</item>
//<item>@color/view_line</item>
//<item>@color/view_line</item>
//<item>@color/view_line</item>
//</array>
//<array name="array_dot_inactive2">
//<item>@color/text_color_white</item>
//<item>@color/text_color_white</item>
//<item>@color/text_color_white</item>
//<item>@color/text_color_white</item>
//</array>
//</resources>


let DEFAULT = UserDefaults.standard
let APPCOLOL = UIColor.init(red: 35/255, green: 166/255, blue: 152/255, alpha: 1)
let PROFILECOLOL = UIColor.init(red: 95/255, green: 122/255, blue: 207/255, alpha: 1)
let APPTEXTLIGHTCOLOL = UIColor.init(red: 135/255, green: 158/255, blue: 183/255, alpha: 1)

let STATUSBARCOLOR2 = UIColor.init(red: 244/255, green: 247/255, blue: 255/255, alpha: 1)
let STATUSBARCOLOR = UIColor.init(red: 233/255, green: 238/255, blue: 255/255, alpha: 1)

let APPTEXTCOLOL = UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1)

let SELECTEDLINECOLOL = UIColor.init(red: 94/255, green: 127/255, blue: 158/255, alpha: 1)
let DELETEACCOUNTCOLOL = UIColor.init(red: 255/255, green: 110/255, blue: 64/255, alpha: 1)

let VIEWGALLYCOLOL = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
let YELLOWMARKERCOLOL = UIColor.init(red: 255/255, green: 159/255, blue: 0/255, alpha: 1)

let CALENDERCOLOL = UIColor.init(red: 35/255, green: 48/255, blue: 64/255, alpha: 1)
let FINDCOLOL = UIColor.init(red: 156/255, green: 177/255, blue: 194/255, alpha: 1)

let APPDEL = UIApplication.shared.delegate  as! AppDelegate
let SCREENWIDTH = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height
let TOPHEIGHT = UIApplication.shared.statusBarFrame.height + 60.0
let CURRENTTIMEZONE = Calendar.current.timeZone.identifier
let latX = DEFAULT.value(forKey: "CURRENTLAT") as? String ?? "30.0"
let longX = DEFAULT.value(forKey: "CURRENTLONG") as? String ?? "76.0"
var CURRENTLOCATIONLAT = Double(latX)!
var CURRENTLOCATIONLONG = Double(longX)!
