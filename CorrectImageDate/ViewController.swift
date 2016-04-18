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
    
    @IBOutlet weak var mFileNameTv: NSScrollView!
    @IBOutlet weak var mCurrFolder: NSTextField!
    @IBOutlet var mFileNamesTv: NSTextView!
    
    func getImageFileFromSelectdDir(pathOfFolder: String) -> [String]? {
        let fileManager = NSFileManager.defaultManager();
        let contents:[String];
        let folderURL = NSURL.fileURLWithPath(pathOfFolder);
        
        do {
            contents = try fileManager.contentsOfDirectoryAtPath(mCurrFolder.stringValue);
            
            // TODO: using .contentsOfDirectoryAtURL to re-implement this value
            let folderCntx = try fileManager.contentsOfDirectoryAtURL(folderURL, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles);
            
            let files = (folderCntx.map(){$0.lastPathComponent})
            var cnt = 0;
            /*
            
            let jpgFilesArray = (NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectoryURL, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles | .SkipsSubdirectoryDescendants | .SkipsPackageDescendants, error: nil) as! [NSURL]).sorted{$0.lastPathComponent<$1.lastPathComponent}.filter{$0.pathExtension!.lowercaseString == "jpg"}

            let fileNames = contents as [String];
            for fileName in contents {
                if (fileName.hasSuffix(".jpg")) {
                    print("[\(cnt)]:\(fileName)");
                    cnt++;
                }
            }
            */
            
            cnt = 0;
            var fileNames = [String] ();
            for URLS in folderCntx {
                let pathStr:String = URLS.relativePath!;
                let ext:String = URLS.pathExtension!;
                let fileName: String? = URLS.lastPathComponent;
                
                if (ext.lowercaseString == "jpg") {
                    print("[\(cnt)]:\(pathStr)\t\(fileName)");
                    cnt++;
                    
                    fileNames.append(fileName!);
                } else {
                    // skip not jpg
                    continue;
                }
                
                
                
                let fileAttr = try NSFileManager.defaultManager().attributesOfItemAtPath(pathStr);
                let creationDate = fileAttr[NSFileCreationDate] as? NSDate;
                let modificationDate = fileAttr[NSFileModificationDate]
                print("[File] creation date \(creationDate)")
                //print("modification date of file is \(modificationDate)")
                
                
                
                //let imageSrc: CGImageSourceRef? = CGImageSourceCreateWithURL(URLS, nil);
                //let imageProps: NSDictionary? = CGImageSourceCopyPropertiesAtIndex(imageSrc!, 0, nil)
                
                let imageSrc: AnyObject? = CGImageSourceCreateWithURL(URLS, nil);
                let imageProps: AnyObject? = CGImageSourceCopyPropertiesAtIndex(imageSrc! as! CGImageSource, 0, nil)
                
                
                if (imageProps == nil) {
                    print("\(pathStr) is not invalid image type!!");
                    //continue;
                }
                
                //let exif: NSDictionary? = imageProps[/*"{Exif}"*/kCGImagePropertyExifDictionary] as! NSDictionary?;
                //let exif: NSDictionary? = imageProps?["{Exif}"] as! NSDictionary?;
                //let exif =  imageProps[/*"{Exif}"*/kCGImagePropertyExifDictionary] //as? rn_CGPropDictionary;
                let exif: AnyObject? = imageProps?.objectForKey(kCGImagePropertyExifDictionary);
                
                
                //test(URLS)
                
                
                //print("!!\(imageProps)")
                
                if (exif != nil) {
                    //let tm: String? = exif!["DateTimeOriginal"] as! String?
                    let tm: AnyObject? = exif?.objectForKey(kCGImagePropertyExifDateTimeOriginal);
                    if (tm != nil) {
                        print("[Exif] original date \(tm!)")
    
                        //var dateFormater = NSDateFormatter();
                        //dateFormater.dateFormat = "
                        
                    } else {
                        print("## no date info")
                    }
                } else {
                    print("@@ no exif img ##")
                }
            }
            
    
            return fileNames;
        } catch let error as NSError {
            print (error.localizedDescription);
            return nil;
        }
    }
    
    func test(url: NSURL) {
        let imageSrc = CGImageSourceCreateWithURL(url, nil);
        let imageProps: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSrc!, 0, nil)!//CGImageSourceCopyProperties(imageSrc!, nil);
        
        //let exif: NSDictionary? = imageProps[/*"{Exif}"*/kCGImagePropertyExifDictionary] as! NSDictionary?;
        let exif: NSDictionary? = imageProps["{Exif}"/*kCGImagePropertyExifDictionary*/] as! NSDictionary?;
        
        //let exif =  imageProps[/*"{Exif}"*/kCGImagePropertyExifDictionary] //as? rn_CGPropDictionary;
        
        
        
        //let imageProps1: CFDictionaryRef = CGImageSourceCopyPropertiesAtIndex(imageSrc!, 0, nil)!;
        //let exif1 = CFDictionaryGetValue(imageProps1, kCGImagePropertyExifDictionary)
        var exif1:AnyObject? = imageProps.objectForKey(kCGImagePropertyExifDictionary)
        print("!!\(exif1)!!")
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
                //printFilesInFolder();
                let fileNames = getImageFileFromSelectdDir(mCurrFolder.stringValue);
                
                mFileNamesTv.textStorage?.mutableString.setString("")
                for fileName in fileNames! {
                    mFileNamesTv.insertText("\(fileName)\n")
                }
            }
        }
    
    }
}

