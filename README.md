# Khaoyai-MobileApplication-iOS
Open source for National Park of Thailand, Khaoyai in Swift 2.1
This project need some other frameworks to make it works which I've already included in this project:

- AFNetworking
- Toast iOS
- GradientProgress
- Google Analytics
- Bugsense

NOTE: This project is supported iOS that greater than 7.0 and it's tested with iOS 9.2 succuessfully

## How to use an App
This application are supported language in Thai and English, future languages are in consideration. 
- At start up, the application will check with the server authentication if there is any new update from Database. If not, application load information from their local database, Core Data. 
- Information and Images used in application are downloaded in the background when start up
- When there is no internet connection, all data are loaded from the Core Data
- There is 5 Menus at the bottom of the screen is : Home, Howto, Map, Contact, About us

###Home 
The main page it's downloaded information from Arduino Controller that is on the Khaoyai National Park, Arduino Controller are sending humidity, and Temperature to Database every 1 Hr. There is a local news section at the bottom half of Home page. It's the news from officer at Khaoyai that would like to share the Khaoyai suitation and life  on the mountain. Officers's goal is to share something like, "Today there are 3 elephant that come to cafeteria", "Monkeys are stealing visitor belonging, Please Beware" for example

###Howto 
Divided into 4 parts: Travel section, Animal section, Don't do section, Documentary section
- Travel section explained about what to do when you travel, what recommended
- Animal section explained about animal, habit, food, and behavior 
- Don't do section explained about thing you should beware and should'nt do
- Documentary section explained other else that not fit into those 3 categolries early

###Map 
Places where to go with images and details explaination. This path are linked to Howto section to explain more details about this place.

###Contact
The number of contacts in different categories. For visitors to contact officers when they have some errand or emergency

###About
Credit for officers that help National Park and Developers

## Installation
Download as ZIP and extract it. Double-click on Xcode project and everything will work normally

## Who use it
Anyone that's interesting to learn how to code Apple Device with Swift. This project is fully runnable without any external API. and anyone that's intersting to use this project for building application for other National Park, you need to prepare your own domain and API by yourself

## Motivation
Khaoyai National Park is one of the Nation Park in Thailand that receive award to be World Heritage from UNESCO since 2005. Unfortunately, some visitors are not educated enough to know how to do 'sustainable tourism'. Officers at Khaoyai try their best to keep animal and visitors to live togther happily. UNESCO has planned for removed award for World Heritage since 2012 because of environment issue that Thailand can't solve. 

This Application is a hope to help Thailand officers to lower a burden of problem visitors when traveling to Thailand. Application will contain information about what you should do and what you shouldn't do in offline mode.


## API Reference



## Future Features
My next goal is to implements Beacon technology, Login with Facebook, and Gamification for the next release
