# Swift - OpenALPR

## Motivation
I needed to use OpenALPR as a sub-module of a project of mine,
hence this wrapper was born.

# Contents
It's a very simple package to be honest.
In order to make it build, OpenALPR (https://github.com/openalpr/openalpr) 
should be installed on your machine.

It exposes a class called `OpenALPR` which you can import and use the C api through.
It gives you conveiently usable methods, for example `recogniseBy(data:)`
so you don't have to worry about converting the bytes into the appropriate form
for the C API, also it gives you more _Swifty_ typed return values, no _char *_.

Actually it has two methods:
- `recogniseBy(data:)`
- `recogniseBy(filePath:)`.

Also, you can set how many plates you want it to discover at max. You can see an example of that below.


# Example usage

You don't have to worry about importing the right version of openalpr for your OS, it's handled via a directive in the wrapper.

```swift
import Foundation

var country = "us"
var configFile = "/etc/openalpr/openalpr.conf"
var runtimeFiles = "/usr/local/share/openalpr/runtime_data"

let alprWrapper = OpenALPR(countryCode: country, configFile: configFile, runtimeFilesLocation: runtimeFiles)

// for demo purposes
alprWrapper.maxRecognisablePlateCount = 1

let url = URL.init(string: "http://plates.openalpr.com/h786poj.jpg")!

URLSession.shared.dataTask(with: url) { (data, response, error) in
    if error != nil { fatalError(error.debugDescription) }
    guard data != nil else { fatalError("Downloaded data was nil, and its not allowed in this example") }

    let results = try! alprWrapper.recogniseBy(data: data!)
    print("Result from downloaded IMAGE:")
    print(results)
}.resume()

let results2 = try! alprWrapper.recogniseBy(filePath: "/Users/atesztoth/h786poj.jpg")
print(results2)

RunLoop.main.run()
```

# Pkg managers
Yet only Swift Package Manager is supported. PRs are welcome.
