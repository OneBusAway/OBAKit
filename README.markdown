# OBANetworking

This library is a ground-up rewrite of the networking and modeling modules from OneBusAway for iOS. It is designed to be stable, relatively bug-free, clear, and well-tested. It is designed to serve as the foundation of OneBusAway in its second decade of life.

## Code and Structure

OBANetworking is written almost entirely in Swift 4, with the exception of a few core parts of the library that are not very enjoyable to express in Swift. It is designed to be usable within both Swift and Objective-C projects. The project is divided between a Network Service layer and a Model Service layer, each of which have three service classes designed to work with the three data sources that OneBusAway for iOS depends on:

* Regions API
* REST API
* Obaco API (alerts.onebusaway.org or onebusaway.co)

### Network Services

# Third Party Libraries

## DictionaryCoding

Includes DictionaryCoding code by Sam Deane, Elegant Chaos Limited.

    The original code is copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors

    Licensed under Apache License v2.0 with Runtime Library Exception

    See https://swift.org/LICENSE.txt for license information
    See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

    Modifications and additional code here is copyright (c) 2018 Sam Deane, and is licensed under the same terms.


# Apache 2.0 License

    Copyright 2018 Aaron Brethorst

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.