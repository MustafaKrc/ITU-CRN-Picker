# ITU-CRN-Picker
Automatic crn picking app for ITU's kepler website.

## Table of Contents
* [General Information](#general-information)
* [How to Install](#how-to-install)
* [How to Use](#how-to-use)
* [Things You Should Know](#things-you-should-know)
* [Room for Improvement](#room-for-improvement)
* [License](#license)

## General Information
This is an automated app to pick or drop CRNs from Istanbul Technical University's student information system (aka. kepler) website.

## How to Install
- You need to have **Python 3.\*** and **latest version of Google Chrome web browser** installed in your system.
- Following 3rd party libraries are needed:
    - selenium
    - selenium-wire
    - webdrivermanager
    - dotenv
    > You can use this command to install them in cmd via pip:<br />
    `pip install selenium selenium-wire webdrivermanager dotenv`
- Clone this repository to your computer.

## How to use
- You must edit the `.env` file.
> The necessary information for configiration is given in the file itself.
- Open cmd in the root folder of the cloned file.
- Type `python main.py`

## Things You Should Know
- You cannot send request to kepler more frequent than 1 seconds. Kepler system rejects the post request as a protection mechanism. That is why the maximum frequency to send request is set to 1.1 seconds in the source code.
- This app installs latest web driver for Chrome web browser when it is necessary. You can check how it works from [here](https://github.com/SergeyPirogov/webdriver_manager).

## Room for Improvement
- Badly formatted user information in .env file may cause unpredictable bugs. Better error handling is needed in UserConfig class.

> Feel free to report any bugs you encounter in this repository's issues page.

 ## License
 This project is open source and available under the [GPLv3 License](./LICENSE).