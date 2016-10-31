## Usage

* TopChart is an iOS application that allows you to browse Top 50 music and movie charts from ITunes.
* It supports iOS 9 and above, and works well with all devices on both portrait and landscape mode.
* You can navigate between music and movie list using the tab bar, and pull to refresh content. 
* From music list, tapping on the music will allow you to listen to the preview.
* A tool bar will appear on top of the tab bar to display what song is playing and to play/pause.
* Tapping on the title from the tool bar will scroll your tableview and position the song right above the tool bar.
* Pause button will be replaced with play button when the preview finishes. Tool bar will disappear once paused.
* From movie list, you can tap on the detail accessory to review the movie summary.

## Implementation Summary

`TabBarController` is the root view controller of the application window.
This class is a subclass of `UITabBarController` and owns the music and movie table view controllers.

Both music and movie table view controllers have many similar attirbutes such as fetching top 50 contents
from url. These attributes are implemented in the superclass, `TopChartBaseTableViewController`.
`MusicTableViewCell` and `MovieTableViewCell` interfaces are similary structured as well, so these are inherited
from the superclass, `TopChartBaseCell`.

`CacheManager` is a singleton class that inherits from `NSCache`. It's responsible for
downloading images from url and storing them.

`APIManager` is a static class that handles network request and json serialization.
