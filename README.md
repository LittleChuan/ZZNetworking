# ZZNetworking

[![CI Status](https://api.travis-ci.org/LittleChuan/ZZNetworking.svg?branch=0.1.1)](https://travis-ci.org/LittleChuan/ZZNetworking)
[![Version](https://img.shields.io/cocoapods/v/ZZNetworking.svg?style=flat)](https://cocoapods.org/pods/ZZNetworking)
[![License](https://img.shields.io/cocoapods/l/ZZNetworking.svg?style=flat)](https://cocoapods.org/pods/ZZNetworking)
[![Platform](https://img.shields.io/cocoapods/p/ZZNetworking.svg?style=flat)](https://cocoapods.org/pods/ZZNetworking)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Then replace the id and secret: [QingtingFM](https://open.qingting.fm/documents/124), thanks for the free API.

``` swift
UserService.auth(client_id: "x", client_secret: "x")
```

## Usage

### Config
``` swift
/// default request URL, mark sure modify this
public static var host = "https://www.your.host.modify.this.value.or.404"
/// default request Header
public static var header = ["Content-Type": "application/json"]
/// keypath in data structure which need decode. eg. { code, message, *data* }
public static var keyPath: String?
/// default timeout
public static var timeout = 15.0
/// handle before request
public static var beforeRequest: ((URLRequest) -> ())?
/// handle request success, you can validate
public static var afterRequestSuccess: ((URLResponse, Data) throws -> ())?
/// handle only request failed
public static var afterRequestFailed: ((ZZError) -> ())?

// MARK: - Model
/// Pager Style, default .page(pagesize, page)
public static var pageableSytle = PageableStyle.page()

// MARK: - Debug
/// open debug log
public static var debugLog = false
```

### REST Model
``` swift
struct Channel: ZZRestModel {
    var id: Int
    
    static var servicePath: String { "media/v7" }
    static var path: String { "channelondemands" }
    
    var title: String
    var description: String
}
```
GET
```
Channel.get()
```
### Pager
init
``` swift
let channels = ZZRestPager<Channel>(size: 30, style: .page())
```
refresh & get more
```
channels.refresh()
channels.more()
```
bind to table view with RxSwift
``` swift
channels.list.bind(to: table.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, text, cell) in
        cell.textLabel?.text = text.title
} .disposed(by: bag)
```

## Installation

ZZNetworking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZZNetworking'
```

## Author

ZackXXC, 248254119@qq.com

## License

ZZNetworking is available under the MIT license. See the LICENSE file for more info.
