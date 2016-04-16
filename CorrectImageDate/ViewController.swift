//
//  ViewController.swift
//  CorrectImageDate
//
//  Created by ChenYi-Hung on 2016/4/8.
//  Copyright © 2016年 ChenYi-Hung. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet weak var mCurrFolder: NSTextField!
    
    func printFilesInFolder() {
        let fileManager = NSFileManager.defaultManager();
        
        do {
            let contents = try fileManager.contentsOfDirectoryAtPath(mCurrFolder.stringValue);
            
            // TODO: using .contentsOfDirectoryAtURL to re-implement this value
            
            var cnt = 0;
            let fileNames = contents as [String];
            for fileName in fileNames {
                if (fileName.hasSuffix(".jpg")) {
                    print("[\(cnt)]:\(fileName)");
                    cnt++;
                }
            }
        } catch {
            print("no file in \(mCurrFolder.stringValue)");
            
        }
        
    }
    
    
    
    @IBAction func browseFile(sender: AnyObject) {
        let dialog = NSOpenPanel();
        dialog.title = "Open Images Folder for adjust time"
        dialog.canChooseDirectories = true;
        dialog.canChooseFiles = false;
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.URL;
            
            if (result != nil){
                let path = result!.path!;
                print(path);
                
                mCurrFolder.stringValue = path;
                printFilesInFolder();
            }
        }
    
    }
}

