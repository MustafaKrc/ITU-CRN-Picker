# Deprecated
Please note that this project is no longer actively maintained. We have shifted our focus to a more comprehensive solution, BeeHub, which includes similar functionality and additional features. For the latest updates and improvements, visit [BeeHub](https://beehubapp.com/). We encourage you to check out the new platform, and feel free to reach out if you have any questions or need assistance.

# ITU-CRN-Picker
Automatic CRN picking application for ITU's kepler website.

## Table of Contents
* [General Information](#general-information)
* [How to Install](#how-to-install)
* [How to Use](#how-to-use)
* [Things You Should Know](#things-you-should-know)
* [Room for Improvement](#room-for-improvement)
* [Releases](#releases)
* [License](#license)

## General Information
This is an automated app to pick or drop CRNs from Istanbul Technical University's student information system (aka. kepler) website.

## How to Install

You can either run the release executable or build this repository on your system.

### Run executable

- Simply download the release and run the executable.

### Build from source code


- You need to have **Python 3.\*** and **Google Chrome web browser** (preferably latest version) installed in your system.
- Following 3rd party libraries are needed:
    - PySide6
    - selenium
    - python-dotenv
    - requests
    - urrlib
    > You can use this command to install them in cmd via pip:<br />`pip install -r requirements.txt`
    >> It is recommended to use virtual environment.
    
- Clone this repository to your computer.
- Run `main.py`.

## How to use the application
- Login with ITU information. 
![Login Page](github_images/img01.jpg)
- Create your schedule in `My Schedules`
![My Schedules Page](github_images/img03.jpg)
- Change some settings based on your needs in `Settings`
![Settings Page](github_images/img04.jpg)
- Press `Start Post Requests` button in `Home`
- Relevant information about each CRN is displayed in `Home`
![Home Page](github_images/img02.jpg)

## Things You Should Know
- You cannot send request to kepler more frequent than 1 seconds. Kepler system rejects the post request as a protection mechanism. That is why the maximum frequency to send request is set to 1.1 seconds in the source code.
- This app installs latest web driver for Chrome web browser when it is necessary. It is expected to take some time for download during first time start.

## Room for Improvement
- Schedule creation can be more interactive. User can select offered courses from drop-down menus using [this](https://github.com/itu-helper/data-updater) api.

> Feel free to contribute to the project or report any bugs you encounter in this repository's issues page.

## Releases

- [Version 0.1.1 (January 2024)](https://github.com/MustafaKrc/ITU-CRN-Picker/releases/tag/v0.1.1)
  - Now username and password are encrypted properly.
  - Fixed user photo not showing properly.
  - Fixed webdriver not closing up properly.
  - Fixed slow closing.

- [Version 0.1 (January 2024)](https://github.com/MustafaKrc/ITU-CRN-Picker/releases/tag/v0.1)
  - Introduces GUI layer for improved user experience.
  - Available executables for Windows and Linux.
  - Backend enhancements from the CLI version.

## License
This project is open source and available under the [GPLv3 License](./LICENSE).
