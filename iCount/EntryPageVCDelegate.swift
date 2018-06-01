//
//  EntryPageVCDelegate.swift
//  iCount
//
//  Created by Sadie Flick on 5/25/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import Foundation
import UIKit

protocol EntryPageVCDelegate {
    func saveButtonPressed(num count: Int32?, text goal: String?, goalNum times: Int32?, period timeFrame: Int32?, upperBound upLimit: Bool?, sender indexPath: IndexPath?)
}
