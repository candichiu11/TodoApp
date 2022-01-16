//
//  Design.swift
//  Todoey
//
//  Created by Candi Chiu on 15.01.22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


import UIKit
struct NavigationDesign {
    func navigationSetting(naviController: UITableViewController){
        let theColourWeAreUsing = UIColor.systemTeal
        let contrastColour = UIColor.white
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColour]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColour]
        navBarAppearance.backgroundColor = theColourWeAreUsing
        naviController.navigationItem.standardAppearance = navBarAppearance
        naviController.navigationItem.scrollEdgeAppearance = navBarAppearance
    }
}
