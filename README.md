# Swift - OpenALPR

## Motivation
I just wanted to use OpenALPR... It turned out to be a rather long and painful process to somehow make this work.
It's here so you won't have to go through it yourself. _Keep it, hold it, love it._

https://www.youtube.com/watch?v=uZwHVCqdT7c

# Contents
It's a very simple package to be honest. It is required that you install OpenALPR (https://github.com/openalpr/openalpr) on your machine
yourself, then in theory this wrapper should be able to build and be ready to be used.

It exposes a class called `OpenALPR` which you can import and use the C api through. It gives you conveiently usable methods,
for example `recogniseBy(data:)` so you don't have to worry about converting the bytes into the appropriate form for the C API,
also it gives you more _Swifty_ typed return values, no _char *_.

Actually it has two methods:
- `recogniseBy(data:)`
- `recogniseBy(filePath:)`.

Also, you can set how many plates you want it to discover at max. You can see an example of that below.

So the keyword is: _convenience_, and _usability_. Which is straight the opposite that we can say about the C api and `OpenAlprWrapper` of mine.

# Example usage

You don't have to worry about importing the right version of the wrapper for your OS, it's handled via a directive in the wrapper.

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

    let results = alprWrapper.recogniseBy(data: data!)
    print("Result from downloaded IMAGE:")
    print(results)
}.resume()

let results2 = alprWrapper.recogniseBy(filePath: "/Users/atesztoth/h786poj.jpg")
print(results2)

RunLoop.main.run()
```

# Pkg managers
Yet only Swift Package Manager is supported. PR's are welcome.
