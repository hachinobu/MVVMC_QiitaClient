//
//  DependencyCoordinator.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol DependencyCoordinator: class {
    var childCoordinators: [Coordinator] { get set }
    
    func addDependency(coordinator: Coordinator)
    func removeDependency(coordinator: Coordinator?)
}
