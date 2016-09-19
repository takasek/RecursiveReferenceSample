//
//  ViewController.swift
//  RecursiveReferenceSample
//
//  Created by Yoshitaka Seki on 2016/08/07.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import UIKit

final class MyComponent: UIView {
    @IBOutlet private var button: UIButton!

    //外側からセットできる関数型のプロパティ。
    //Buttonが押された時に実行する
    var callback: (() -> Void)?

    @IBAction func didButtonPush() {
        callback?()
    }
}

final class ViewController: UIViewController {

    @IBOutlet private var component: MyComponent!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let way = way {
            print("\n\n==================")
            print("\(way)を渡しつつ遷移した")
        }
        configureButtonAction()
    }

    private func doHogeMethod() {
        print("method")
    }

    deinit {
        print("deinitされました")
    }

    var way: Way?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if way != nil {
            print("deinitされるかな？　次の行に「deinitされました」と出ればOK")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue as? ViewControllerWithWaySegue, let wayBox = sender as? WayBox {
            segue.way = wayBox.way
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let alert = UIAlertController(title: nil, message: "callback関数を渡す方法は?", preferredStyle: .actionSheet)

        let ways: [Way] = [
            .method,
            .unownedMethod,
            .functionTypeProperty,
            .functionTypePropertyUsingSelf,
            .lazyFunctionTypeProperty,
            .lazyFunctionTypePropertyUsingSelf,
            .localFunc,
            .localFuncUsingSelf,
            .localClosure,
            .localClosureUsingSelf,
            .localClosureUsingUnownedSelf,
        ]
        ways.forEach { (way) in
            alert.addAction(UIAlertAction(title: way.description, style: .default) { [weak self] _ in
                self?.performSegue(withIdentifier: "Segue", sender: WayBox(way: way))
                })
        }

        present(alert, animated: true, completion: nil)

        return sender == nil
    }


    let functionTypeProperty = {
        print("function-type property")
    }

    let functionTypePropertyUsingSelf = {
        print("function-type property using self", self)
    }

    lazy var lazyFunctionTypeProperty = {
        print("lazy function-type property")
    }

    lazy var lazyFunctionTypePropertyUsingSelf = {
        print("lazy function-type property using self", self)
    }

    func configureButtonAction() {
        guard let way = way else { return }

        let localClosure = {
            print("local closure")
        }

        func localFunc() {
            print("local func")
        }

        func localFuncUsingSelf() {
            print("local func using self", self)
        }

        let localClosureUsingSelf = {
            print("local closure using self", self)
        }

        let localClosureUsingUnownedSelf = { [unowned self] in
            print("local closure using unowned self", self)
        }

        switch way {
        case .method:
            component.callback = doHogeMethod

        case .unownedMethod:
            component.callback = { [unowned self] in
                self.doHogeMethod()
            }
        case .functionTypeProperty:
            component.callback = functionTypeProperty

        case .functionTypePropertyUsingSelf:
            component.callback = functionTypePropertyUsingSelf
            
        case .lazyFunctionTypeProperty:
            component.callback = lazyFunctionTypeProperty

        case .lazyFunctionTypePropertyUsingSelf:
            component.callback = lazyFunctionTypePropertyUsingSelf
            
        case .localFunc:
            component.callback = localFunc

        case .localFuncUsingSelf:
            component.callback = localFuncUsingSelf

        case .localClosure:
            component.callback = localClosure

        case .localClosureUsingSelf:
            component.callback = localClosureUsingSelf
            
        case .localClosureUsingUnownedSelf:
            component.callback = localClosureUsingUnownedSelf
        }
    }
}
