/**
 * Copyright (c) 2016 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

// MARK: Constants

private let currentUserKey = "FLICKR_CURRENT_USER_KEY"

// MARK: - IMFlickr

class IMFlickr {
    
    // MARK: - Instance Variables
    
    /**
     *  This class constant provides an easy way to get access
     *  to a shared instance of the MIFlickr class.
     */
    static let shared = IMFlickr()
    
    let api: FlickrApiClient
    var OAuth: FlickrOAuth {
        get {
            return FlickrOAuth(consumerKey: Tagger.Constants.Flickr.applicationKey,
                               consumerSecret: Tagger.Constants.Flickr.applicationSecret,
                               callbackURL: Tagger.Constants.Flickr.OAuthCallbackURL
            )
        }
    }
    
    var currentUser: FlickrUser? {
        get {
            guard let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data,
                let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? FlickrUser else {
                    return nil
            }
            
            return user
        }
        
        set {
            let userDefaults = UserDefaults.standard
            
            if let newValue = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
                userDefaults.set(data, forKey: currentUserKey)
            } else {
                userDefaults.set(nil, forKey: currentUserKey)
            }
            
            userDefaults.synchronize()
        }
    }
    
    // MARK: Init
    
    private init() {
        self.api = FlickrApiClient.shared
    }
    
    // MARK: Public
    
    func logOut() {
        currentUser = nil
        FlickrOAuth.removeTokensFromKeychain()
    }
    
}
