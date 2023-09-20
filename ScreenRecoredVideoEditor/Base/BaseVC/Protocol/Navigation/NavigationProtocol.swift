//
//  NavigationProtocol.swift
//  Beberia
//
//  Created by haiphan on 23/08/2022.
//  Copyright © 2022 IMAC. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationProtocol {}
extension NavigationProtocol {
    
    func moveToEditorVideo(inputURL: URL,
                           delegate: EditorVideoDelegate?,
                           editorVideoType: EditorVideoVC.EditorVideoType) {
        guard let topVC = ManageApp.shared.topViewController() else {
            return
        }
        let editorVC = EditorVideoVC.createVC()
        editorVC.inputVideo = inputURL
        editorVC.delegate = delegate
        editorVC.editorVideoType = editorVideoType
        topVC.navigationController?.pushViewController(editorVC)
    }
    
    func moveToFaceCame(inputURL: URL) {
        guard let topVC = ManageApp.shared.topViewController() else {
            return
        }
        let faceCameVc = FacecamVC.createVC()
        faceCameVc.videoURL = inputURL
        topVC.navigationController?.pushViewController(faceCameVc)
    }
    
}
