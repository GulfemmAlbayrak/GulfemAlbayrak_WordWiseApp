# WordWise App

### WordWise is a dictionary application that allows users to search for word definitions and related information. It utilizes the [dictionaryapi](https://www.dictionaryapi.com/) to retrieve word data. The application features a modular design, providing an intuitive user interface. latest news and presents it to users through a user-friendly interface.

## Features
- **Search Bar:** Users can enter a word in the search bar to retrieve its detailed information.
- **Pronunciation Playback:** If a pronunciation URL is available for a word, users can play the pronunciation using the AVAudioPlayer by tapping the "Play" button. If no pronunciation URL is available, the button will be hidden.
- **Synonyms:** The application displays synonyms of the word at the bottom of the page.
- **Dynamic Cells:** The detail cells in the application have a dynamic structure. In cases where there is no example, the cell size is automatically calculated.
- **Search History:** The application stores the search history using CoreData and displays the five most recent searched words in a tableView on the SearchVC page.
- **Recent Words:** Users can navigate to the WordDetailVC page by tapping on a word in the tableView.
- **Keyboard:** The application includes a special feature where the search bar is positioned above the keyboard when it appears and returns to its original position when the keyboard is dismissed.
 
## Dependencies
- Alamofire: A networking library used for making API requests.
- AVAudioPlayer: Used for downloading and caching images. It provides an easy way to load and display images from URLs obtained from the New York Times API.
- Core Data: Enables data persistence for saving recent words.

 ## Media

| SearchVC                     | WordDetailVC               | 
| ---------------------------- | -------------------------- | 
| <img src="https://github.com/GulfemmAlbayrak/GulfemAlbayrak_HW3/assets/101430350/4b292aa6-cc52-4f96-bd4e-73ccf8cd408b" width="300px"> | <img src="https://github.com/GulfemmAlbayrak/GulfemAlbayrak_HW3/assets/101430350/341fe5e9-ea0f-48d5-a421-26791ea6f65a" width="300px"> |



|                              |                              |         
| ---------------------------- | ---------------------------- |
| ![FirstPart](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzU1YTEzNzUyODcyMzc0YjlkZDZiYzU2MGMwYjVmZmQ4NzcwZTA1NyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/3UAD2wmpTRSCuwNb7L/giphy.gif) | ![SecondPart](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDUzNjkzNTQ5OGY3MTNkZmJhOWE3MTYzNTE5Zjc0NmQ5NTY4MTgzMCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/ogr7DRHGuXcPakR5EB/giphy.gif) |

