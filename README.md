# Small cap investing visualiser app for iOS 

An iOS app based on [Mr. Shankar Nath's](https://www.youtube.com/@shankarnath) Small Cap Investing Strategy [video on YouTube.](https://www.youtube.com/watch?v=ppxnjQ86T-Q)

The app supports `iOS 15.0` and above and is built using `Xcode 14.2`

Download or clone the repository to view the source code. Build and run the app either on the iOS simulator or on a physical device.
Once installed you will see the **Small Cap Inv** app icon on the dashboard, tap to launch the app.
The app uses `Combine` framework to make network requests to the `niftyindices.com` API and displays the TRI in the UI on receiving a successful response.
Note that the TRI displayed is of the `previous day` only.

The app uses Firebase in order to persist data locally as well as in the Firestore. This enables multiple instances of the app to be in sync with the online database so as to view the data if it was already queried for by any app instance from the API, thereby preventing additional calls to it.

<img src="https://github.com/anupdsouza/ios-smallcap-investing-visualiser/assets/103429618/2bf4a4c1-c99e-459c-82fb-b4fb7254f333">


## Screenshots
<img src="https://github.com/anupdsouza/ios-smallcap-investing-visualiser/assets/103429618/8e95394b-0bce-4ecb-b0cc-c45ad7e7bb21" width="150">
<img src="https://github.com/anupdsouza/ios-smallcap-investing-visualiser/assets/103429618/498b7cb9-3194-44f9-87a0-dd150d46d232" width="150">
<img src="https://github.com/anupdsouza/ios-smallcap-investing-visualiser/assets/103429618/e1033b68-5882-455f-85e7-deba044d3bc9" width="150">
<img src="https://github.com/anupdsouza/ios-smallcap-investing-visualiser/assets/103429618/67e83dd4-2a65-4d2d-b59a-76a130ec5b6e" width="150">

## Video
![Simulator Screen Recording - iPhone 14 - 2023-08-08 at 13 01 28](https://github.com/anupdsouza/ios-smallcap-investing-visualiser/assets/103429618/7c4d469d-2dad-4b97-972c-82919d1dad5b)

## Stay Connected 🤙🏼
- <picture><img align="center" alt="star the repo" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/star.png" height="20" hspace="5"></picture><a href="https://github.com/anupdsouza/ios-scratch-card-view">Star the Repo</a>
- <picture><img align="center" alt="youtube" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-yt.png" height="20" hspace="5"></picture><a href="https://www.youtube.com/@swiftodyssey">Subscribe on YouTube</a>
- <picture><img align="center" alt="buymeacoffee" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-bmc.png" height="20" hspace="5"></picture><a href="https://www.buymeacoffee.com/adsouza">Buy Me a Coffee</a>
- <picture><img align="center" alt="patreon" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-patreon.png" height="20" hspace="5"></picture><a href="https://patreon.com/adsouza">Become a Patron</a>
- <picture><img align="center" alt="x" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-x.png" height="20" hspace="5"></picture><a href="https://x.com/swift_odyssey">Follow me on X</a>
- <picture><img align="center" alt="github" src="https://github.com/anupdsouza/ios-miscellaneous/blob/bf5cb23d0ffbb21afa7b442540a7682df27c3b12/ic-gh.png" height="20" hspace="5"></picture><a href="https://github.com/anupdsouza">Follow me on GitHub</a>

Your support makes projects like this possible!
Once again, thanks to [Mr. Shankar Nath](https://www.youtube.com/@shankarnath) for the informative strategy video and to [@NithishB06](https://github.com/NithishB06) for the web based small cap bot.
