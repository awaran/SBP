#SBP

SBP is a library that makes Objective C UI more maintainable by utilizing Storyboards and code together.

SBP currently allows you to do two things quickly:
- Produce static animations with autolayout in a maintainable way
- Switch from storyboard views ment for all screen sizes to specalized views for screen sizes and back again



## How To Get Started

### Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. See the ["Getting Started" guide for more information](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking).

#### Podfile

```ruby
platform :ios, '5.0'
pod "SBP"
```

### Tutorial Youtube Videos can be found here

### Example github project
https://github.com/awaran/SBPExample


## More Details

#### Include before use
```ruby
#import "UIViewController+SBP.h" //A category that adds on functionality to viewcontrollers
```

#### Swap two views layouts with animation
```ruby
- (void)switchViewConst:(UIView*)firstView secondView:(UIView*)secondView durationInSeconds:(double)durationInSeconds
```

#### Split universial screen size Storyboard path to multiple screen size paths

* Postfix the segue identifier strings with these
- @“_3_5”  //for the 3.5 inch screens
- @“_4”  //for the 4 inch screens
- @“_4_7” //for the 4.7 inch screens
- @“_5_5” //for the 5.5 inch screens

* Pick a single prefix segue identifier.  If you choose @"hello_world" as your prefix, your segue identifiers should look like this
- @“hello_world_3_5”
- @“hello_world_4”
- @“hello_world_4_7”
- @“hello_world_5_5”

* Use this method to split the single Storyboard path into multiple screen paths
```ruby
- (void)segueScreenSizeSplit:(NSString*)baseSegueName
```

* If you had chosen @"hello_world" as your prefix and you were in the viewcontroller that needed to split the path, the code should look something like this
```ruby
[self segueScreenSizeSplit:@"hello_world"];
```


## Extra
- This is my first open source project and would like to colaborate with others.  Please email me if you have any comments or questions at waran.arjay@gmail.com.  
- P.S. I'm also looking for work in the Bay Area, San Diego or around New York.


## Author

Arjay, waran.arjay@gmail.com

## License

SBP is available under the MIT license. See the LICENSE file for more info.
