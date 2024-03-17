# Movie Night App

## Overview
The Movie Night App is a cross-platform application developed using Flutter, designed to enhance movie selection experiences for groups. It allows users to simultaneously browse, vote on movies, and achieve consensus with ease. The app integrates with The Movie Database (TMDB) API for movie browsing and a custom MovieNight API for session management and voting.

## Features
- **Welcome Screen**: Choose to start a new session or join an existing one using a shared code.
- **Share Code Screen**: Generates a code to share with another user to start movie matching.
- **Enter Code Screen**: Enter a shared code to join a movie matching session.
- **Movie Selection Screen**: Swipe through movies fetched from TMDB, vote, and find matches.

## Technologies Used
- Flutter for cross-platform development.
- TMDB API for movie data.
- MovieNight API for session and voting management.
- HTTP and asynchronous programming for network requests.
- SharedPreferences for local data storage.
  
## Credits
Developed as part of the final project for the Multi-Platform Mobile App Development course.

## Getting Started
To run the app, clone the repository and open it in your Flutter development environment. Ensure you have Flutter and Dart installed and set up.

```bash
git clone <https://github.com/isla0072/Movie-Night-App>
cd movie-night-app
flutter pub get
flutter run

