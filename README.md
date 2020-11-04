# Swift - OpenALPR

## Wait... Don't you already have a wrapper?
Yes, I do. But this package exposes an actually usable wrapper for you to use.
I've gone through the painful process of making this work. This is here, so you won't have to.

# Contents
It's a very simple package to be honest. It's dependent on my other package, which is only exposed via GitLab. I prefer that.
It exposes a class called `OpenALPR` which you can import and use the C api through. It gives you conveiently usable methods,
for example `recogniseBy(_ data:)` so you don't have to worry about converting the bytes into the appropriate form for the C API.

So the keyword is: _convenience_, and _usability_. Which is straight the opposite that we can say about the C api and `OpenAlprWrapper` of mine.

# Example usage

```Swift
// Taking proper care of the import.
#if canImport(Darwin)
import Darwin
import OpenAlprMac
#else
import Glibc
import OpenAlprLinux
#endif

import Foundation

var country = "us"
var configFile = "/etc/openalpr/openalpr.conf"
var runtimeFiles = "/usr/local/share/openalpr/runtime_data"
let alprWrapper = OpenALPR(countryCode: country, configFile: configFile, runtimeFilesLocation: runtimeFiles)

let url = URL.init(string: "http://plates.openalpr.com/h786poj.jpg")!

URLSession.shared.dataTask(with: url) { (data, response, error) in
    if error != nil { fatalError(error.debugDescription) }
    guard data != nil else { fatalError("Downloaded data was nil, and its not allowed in this example") }

    let results = alprWrapper.recogniseBy(data: data!)
    print(results)
}.resume()

let results2 = alprWrapper.recogniseBy(filePath: "/Users/atesztoth/h786poj.jpg")
print(results2)

```

# Pkg managers
Yet only Swift Package Manager is supported. PR's are welcome.
