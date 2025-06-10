# Orgone Interactive Concert App

This is a suite of interactive applications created for a live experimental music concert, developed by Apo33. It enables real-time audience participation in concerts via Android devices and a central concert control app that handles incoming OSC messages.

---

## Applications

### 1. Android App Test (`androidAppTest`)

A Processing/Android app for audience members to connect to the concert, vote on musical directions, and select from a group of musicians to follow the instructions displayed on the screen.

**Features:**
- OSC communication with the concert server.
- Player selection (default: 5 players, dynamically updated).
- Music voting: Texture, Rhythmic, Abstract, Silence, Skip.
- Round timer with automatic vote reset.
- Connect/disconnect management via OSC.
- Touch interface for all controls.

**How it works:**
- Launch the app and tap "connect" to join the concert.
- Choose your players and vote for music categories each round.
- The timer synchronizes voting; votes reset at each round.

---

### 2. Interactive Concert App (`concertInteractif`)

The main concert control app runs on a computer. It receives audience input, manages voting, displays instructions and shapes, and controls the concert flow.

**Features:**
- OSC server for audience communication.
- Dynamic player management and naming.
- Voting logic: collects and processes audience votes.
- Visual feedback: displays instructions and shapes based on votes.
- Timer for round synchronization.
- Keyboard shortcuts for concert control (see code for details).

**How it works:**
- Start the app and set the number of musicians.
- Audience connects and votes via Android devices.
- The app displays the winning instruction and shape each round.
- Use keyboard controls to manage the concert.

---

## Dependencies

### Processing Version

- **Processing 4.3.4**  
  All applications in this suite were developed and tested using Processing version 4.3.4.  
  > ⚠️ Note: The Android app is not compatible with Processing 4.4 due to compilation issues. Please use Processing 4.3.4 for compiling and running both the desktop and Android apps.

### Libraries Used

- **oscP5**  
  Used for Open Sound Control (OSC) communication between the Android app and the concert control app.  
  - [oscP5 library documentation](http://www.sojamo.de/libraries/oscP5/)

- **netP5**  
  Required by oscP5 for network communication.

- **Android Mode for Processing**  
  Required for compiling and running the Android app.

> Make sure to install these libraries via the Processing IDE’s Contribution Manager before running or compiling the apps.

---

## Known Bugs

- **Input Handling:**  
    The program crashes if your input is not an integer (e.g., entering a string or a number larger than 10). This is due to a null pointer error and should be fixed by verifying input types and limiting the number of players to a maximum of 10.

- **OSC Communication:**  
    The Android app sometimes does not recognize incoming OSC messages from the main program running on a computer.

- **IP Management:**  
    IP addresses are not removed when exiting the Android app, which can lead to duplicate IPs if you reconnect.

- **Voting Logic:**  
    Users can vote multiple times per round because the timer is constantly refreshing. This should be resolved by sending the current time from the main app to Android users via OSC.

- **Android Compatibility:**  
    There is an error when compiling the Android app using Processing 4.4. It is recommended to use Processing 4.3.

- **concertInteractif-specific:**  
    - Player names must be manually assigned; there is no UI for editing names during a session.
    - Shapes may not always match the winning vote if multiple OSC messages arrive simultaneously.
    - The app may freeze if an invalid number of musicians is entered.
    - No error handling for missing or malformed `instructions.json`.

---

## Future Improvements

- Make the voting for the number of players change dynamically.
- Improve the visual quality of the shapes (most were quickly inserted into the program with AI, but inspired from original models created by Snati1206).
- Shorten the Bezier shape, which is currently too long.
- Create a function to input player names dynamically (currently handled by a static string array).
- Limit the number of players to 10.
- Add dynamic WiFi connection handling so the app adapts to the current network IP.
- Allow the Android app to receive the number of players and their names after pressing connect, instead of using static values.
- Add feedback to users when their vote is received.
- Improve UI responsiveness and compatibility with more Android devices.
- Allow dynamic server IP configuration from the app UI.
- Add a graphical interface for editing player names and numbers.
- Improve synchronization and error handling for OSC messages.
- Visualize voting results in real time for the audience.
- Add support for more complex instructions and shape animations.
- Implement logging and session recording for post-concert analysis.

---

## Installation & Usage

### Download

- The main concert file (Windows and Linux available)
- The Android concert APK (no support for iOS)

### Installing
- Unzip the downloaded files to a folder of your choice.
- For Windows: Double-click the executable file to start the main concert application.
- For Linux: Open a terminal, navigate to the folder, and run `./concertInteractif`.
- An alternative is using the processing IDE to run the 'concertInteractif' app.
- On Android: Enable installation from unknown sources in your device settings, then open the APK file to install the app.
- The main concert application does not require installation. Make sure your firewall allows network connections.
- The Android APK file must be installed on your phone.

### Usage

- Use a router or a common WiFi network that allows multiple users, as communication is via OSC.
- Connect your computer to the network.
- Launch the main concert program.
- Type the number of musicians for the concert and press ENTER.
- The main concert application is now ready to receive incoming messages and display results at the end of each round.
- To stop, just close the app.

#### For the Android App

- Once installed, connect to the chosen network (do this before launching the app for best results).
- Launch the application.
- Press the CONNECT button. If it turns green, you can start voting (you can activate/deactivate players at any time, but only vote for one action per round).
- Close the app when you want to opt out.

---
## License

This project is licensed under the GNU General Public License v3.0.  
See the [license.txt](LICENSE.txt) file for details.

---

For more information, bug reports, or contributions, please contact Apo33 or visit [apo33.org](https://apo33.org).