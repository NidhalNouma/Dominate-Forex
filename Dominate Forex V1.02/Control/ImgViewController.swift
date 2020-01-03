//
//  ImgViewController.swift
//  Dominate Forex V1.02
//
//  Created by mac on 1/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SDWebImage

class ImgViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrolV: UIScrollView!
    @IBOutlet weak var imgL: UIImageView!
    
    var imgT:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrolV.delegate = self
        
        if let fim = imgT {
            imgL.sd_setImage(with: URL(string: fim), completed: nil)
            
        }
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgL
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
