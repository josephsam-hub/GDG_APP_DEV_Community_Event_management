# Event Management App

## Overview

The Event Management App is a Flutter application designed to streamline the process of managing events. Built using GetX for state management and Firebase for backend services, this app allows organizers to create and manage events, and participants to register and receive unique QR codes. These QR codes are used for check-in on the event day, providing real-time participant counts and event statistics.

## Features

- **Event Creation and Management**: Organizers can create events, specify event details, and manage participants.
- **Participant Registration**: Participants can register for events, and upon successful registration, they receive a unique QR code.
- **QR Code Redemption**: On the event day, organizers can scan participants' QR codes to check them in.
- **Real-Time Participant Count**: The app provides a real-time count of participants who have registered and checked in.
- **Event Statistics**: Minor statistics related to participant demographics and event attendance are displayed.

## Tech Stack

- **Flutter**: The core framework used to build the mobile application.
- **GetX**: State management, dependency injection, and routing.
- **Firebase**: Backend services, including authentication, Firestore for database management, and Firebase Storage for storing QR codes.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/josephsam-hub/GDG_APP_DEV_Community_Event_management
   cd event-management-app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**:

4. **Configure the app**:
 
5. **Run the app**:
   ```bash
   flutter run
   ```
## Usage

### Organizers

1. **Create an Event**: Navigate to the event creation screen and fill in the event details.
2. **Manage Participants**: View the list of participants who have registered for the event.
3. **QR Code Scanning**: On the event day, use the app to scan participants' QR codes for check-in.
4. **View Statistics**: Monitor real-time participant counts and view minor statistics related to the event.

### Participants

1. **Register for an Event**: Browse available events and register for the one you wish to attend.
2. **Receive QR Code**: After registration, receive a unique QR code that will be used for check-in on the event day.
3. **Attend Event**: Present the QR code at the event for scanning by the organizer.

