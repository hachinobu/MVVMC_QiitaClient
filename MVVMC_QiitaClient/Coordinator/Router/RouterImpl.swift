//
//  RouterImpl.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class RouterImpl: Router {
    
    typealias CompletionHandler = (() -> Void)
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: CompletionHandler]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completions = [:]
    }
    
    func setRoot(presentable: Presentable?, hideBar: Bool) {
        guard let controller = presentable?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRoot(animated: Bool) {
        guard let controllers = rootController?.popToRootViewController(animated: animated) else {
            return
        }
        controllers.forEach { runCompletion(controller: $0) }
    }
    
    func present(presentable: Presentable?, animated: Bool) {
        guard let controller = presentable?.toPresent() else {
            return
        }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(presentable: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = presentable?.toPresent(), (controller as? UINavigationController) == nil else {
            return
        }
        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        guard let controller = rootController?.popViewController(animated: animated) else {
            return
        }
        runCompletion(controller: controller)
    }
    
    private func runCompletion(controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
}
