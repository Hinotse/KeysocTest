# Installations:
Open the project with the Xcode application and run it with the simulator or actual device.

# Description:
Pagination:
The pagination can limit the search result to 20 records. The main problem is we can't calculate the last page of the search result, since the endpoint (API) can't count the final result.
My approach is to lock the next page button until the API call contains more than 20 results which means that the next page is available, and then I will unlock the next page button.

Multiple Language:
I use the Localization method to implement the multiple language functions. There are some files to record which key pairs to which translated words. The language setting can be edited in the BookmarkView.
Also, the language status will be stored in AppStorage.

Bookmark:
After the user tap "Add to Bookmark" button, the item information will save in the list, which is saved in UserDefault.
Also, the user can repeat the same action to remove the bookmark.

Search:
The search function will call the API when the search bar has not been edited in one second.

Item Details:
After the searching, each item can be accessed by tapping the row of the list. Some information will be displayed on the next page.
