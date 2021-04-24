# Motivatoional Quotes/አነቃቂ ንግግሮች

Motivatoional Quotes/አነቃቂ ንግግሮች is a mobile application that contains world known famous people's quotations from around the globe and motivates, inspires and pumps up users to grow, enrich and better themselves.

## How to Run

- Either clone or download the project from this repository to a computer
- Install fluter in your computer (use this link: <https://flutter.dev/docs/get-started/install> )
- Connect phone with computer with us debugging on (use this link: <https://developer.android.com/studio/debug/dev-options>)
- Open a terminal and navigate to project folder
- Run the following command
  - flutter pub get && flutter run

## How to Use the App

- Home/quotes tab
  - tap on quotes to change quotes
  - tap on author to show more information about the person
  - tap on share icon to share quote
  - tap on heart icon to like/unlike quote and add/remove quote from favorites
  - tap on top-right corner icon to change language of the application
  - swipe left and right to change screens
- Favorites tab
  - tap on quote from the list to view detailed page of the quote
  - tap on garbage can icon to remove quote from favorites
  - just after removing, tap on the undo button showing to revert changes and add removed quote to favorites again
  - swipe left and right to change screens
- Categories tab
  - tap on any ctegory from list to display quotes within the selected category
- Categories display page
  - swipe lef and right to change quotes
  - tap on download button to save screenshot of the quote

## User Stories

- A user can browse through different quotes
- A user can like/dislike these quotes
- A user can share these quotes
- A user can save the screenshots to their gallery for fututre use like profile picture, wallpaper
- A user can change langauage the language of the app between English and Amharic

## Features

- Quotes
  - quotes are fetched from a .json file in the application directory and are displayed in the application
  - each quote is categorized in 4 different categories and can be individually browsed making quote search easier
- Author
  - users can get detailed information about authors of these quotes from the internet
- Like Quotes
  - liking a quote sends the data to the backend (sqlite database) and is saved there permanently for future access
  - liked quotes are displayed in the faorites tab as a list and are also indicated by a filled-heart icon in all other pages
 -Unliking Quotes
  - liked quotes can be deleted from the favorites tab which removes them from the database
  - deleted quotes can be instantly saved back to the database by using undo implementation
- Share Quotes
  - quotes can be shared to other people through diffent platforms
- Saving Screenshots
  - screenshots of the quotes including their respective backgrounds can e taken and be saved for future access in the galley of user's phone
- Localization
  - users are able to switch between two main app supported locales (English and Amharic) inside the app for prefered usage
  - these locales are saved in shred preferences so that when user next opens application, the previous used locale will be enabled
- Local Push Notifications
  - local push notifications are displayed in background no matter the state of the app (wether closed or open)
- Splash Screen
  - users are greeted at first with a simplistic but descriptive splash screen
- Zero State App Showcase
  - upon installation and first time usage of the app, users are greeted with the basics of the application through a showcase of the app

## Future features

- settings page to help the user get more access of the features of the app like switching language, font size of texts, about us, contact info....

## Dependencies

- Dart >=2.11.0
- Flutter v2.0.4

- pubspec.yaml

  - flutter_localizations:
  - collapsible: ^1.0.0
  - cupertino_icons: ^1.0.0
  - emojis: ^0.9.3
  - equatable: ^2.0.0
  - flutter_bloc: ^7.0.0
  - flutter_launcher_icons: ^0.9.0
  - flutter_local_notifications: ^5.0.0
  - flutter_svg: ^0.21.0+1
  - image_gallery_saver: ^1.6.8
  - path: ^1.8.0
  - path_provider: ^2.0.1
  - permission_handler: ^6.1.1
  - screenshot: ^0.3.0
  - share: ^2.0.1
  - shared_preferences: ^2.0.5
  - showcaseview: ^0.1.6
  - splashscreen: ^1.3.5
  - sqflite: ^2.0.0+3
  - timezone: ^0.7.0
  - workmanager: ^0.2.3
  - url_launcher: ^6.0.3
  - connectivity: ^3.0.3
  
## Screenshots

#### Home Tab

<img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_15-58-24.jpg" alt="home tab english" width="200"/>               <img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-03.jpg" alt="home tab amharic" width="200"/>

#### Favorites Tab

<img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-09.jpg" alt="favorites tab english" width="200"/>               <img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-14.jpg" alt="favorites tab amharic" width="200"/>

#### Categories Tab

<img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-28.jpg" alt="categories tab english" width="200"/>               <img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-20.jpg" alt="categories tab amharic" width="200"/>

#### Quote Display Page

<img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-53.jpg" alt="quote display english" width="200"/>               <img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-46.jpg" alt="quote display amharic" width="200"/>

#### Screenshot

<img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-56-57.jpg" alt="screenshot" width="200"/>

#### Local Notification (Inside/Outside App)

<img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-33.jpg" alt="local notification inside app" width="200"/>               <img src="https://github.com/AlAswaad99/Flutter-MotivationalQuotesApp/blob/master/screenshots/photo_2021-04-24_14-57-39.jpg" alt="local noification background outside app" width="200"/>

