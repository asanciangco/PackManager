[![Build Status](https://travis-ci.org/asanciangco/PackManager.svg?branch=master)](https://travis-ci.org/asanciangco/PackManager)

# Pack Manager

Packing is hard. Weather reports are accurate only up to a couple of days before you depart, meaning that travel plans made weeks in advance can be spoiled by a surprise storm. People need a travel planner that keeps up to date with the places that they're going, that automatically informs them if things change, and advises them on what to bring.

Pack Manager gives you a wardrobe list based on the weather of where you're going. It takes your (1) location, (2) time of travel, (3) personal dressing preferences, and gives you a set of clothes for you to wear and necessities that you can't forget. The goal is to make packing for an outing simple and fast. The application will have a very clean user interface; since its function is simple, its use must be equally simple. The application must be extensible, which means that adding new features must be a well-defined process that is easy.

# Building and Running

Pack Manager is made using Objective-C in XCode. To run simply:

* Acquire Xcode.
* Install Nocilla for testing
    - First install Cocoapods: `$ sudo gem install cocoapods`
    - Next install dependencies (from root project directory run) `$ pod install`
* Load the project into Xcode using the `PackManager.xcodeproj` file.
* Run the project in the iOS emulator using `Run` in Xcode.
