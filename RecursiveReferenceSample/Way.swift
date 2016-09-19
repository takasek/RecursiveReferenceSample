//
//  Way.swift
//  RecursiveReferenceSample
//
//  Created by Yoshitaka Seki on 2016/08/07.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import UIKit

final class ViewControllerWithWaySegue: UIStoryboardSegue {
    var way: Way?
    override func perform() {
        (destination as? ViewController)?.way = way
        super.perform()
    }
}

enum Way: CustomStringConvertible {
    case method
    case unownedMethod
    case functionTypeProperty
    case functionTypePropertyUsingSelf
    case lazyFunctionTypeProperty
    case lazyFunctionTypePropertyUsingSelf
    case localFunc
    case localFuncUsingSelf
    case localClosure
    case localClosureUsingSelf
    case localClosureUsingUnownedSelf
    var description: String {
        switch self {
        case .method:
            return "メソッド"
        case .unownedMethod:
            return "メソッド([unowned self]なクロージャから呼ぶ)"
        case .functionTypeProperty:
            return "関数型プロパティ"
        case .functionTypePropertyUsingSelf:
            return "関数型プロパティ(中でselfを使う)"
        case .lazyFunctionTypeProperty:
            return "lazy関数型プロパティ"
        case .lazyFunctionTypePropertyUsingSelf:
            return "lazy関数型プロパティ(中でselfを使う)"
        case .localFunc:
            return "ローカルfunction"
        case .localFuncUsingSelf:
            return "ローカルfunction(中でselfを使う)"
        case .localClosure:
            return "ローカルクロージャ"
        case .localClosureUsingSelf:
            return "ローカルクロージャ(中でselfを使う)"
        case .localClosureUsingUnownedSelf:
            return "ローカルクロージャ(中でunowned selfを使う)"
        }
    }
}
class WayBox: AnyObject {
    let way: Way
    init(way: Way) { self.way = way }
}
