# winadmin
Get Admin fast on any windows pc

## 📚 Overview

`dan-admin` is a powerful utility designed to bypass Windows authentication and establish a secondary account with administrative privileges. This tool is intended for responsible and ethical use.

## 📦 Prerequisites

Before you begin, ensure you have the following:

- A USB stick
- [Rufus](https://github.com/pbatard/rufus/releases/latest) (or use dd)

## 🚀 Setup

Follow these steps to set up `dan-admin`:

1. run `build.sh` to download and build the custom alpine iso
2. Launch Rufus.
3. In Rufus, select your USB stick as the device.
4. Click "SELECT" and navigate to the built `custom-boot.iso`.
5. Click "START".
6. Choose "Write in ISO image mode" and click "OK".

## 💻 Usage

To use `dan-admin`, follow these steps:

1. Connect the USB to the target Windows machine.
2. Restart the machine and repeatedly press the boot manager key (usually F12).
3. Boot from the Alpine USB and wait for it to load.
4. When prompted for login, enter "root".
5. Execute the following commands:
    ```bash
    cd /media/usb
    chmod +x *.sh
    ./admin.sh
    ```
6. Follow the on-screen instructions and enter the correct partition (usually "/dev/sda3").
7. After seeing the "Done!" message, power off the machine using the "poweroff" command and remove the USB.
8. Boot into Windows as usual.
9. Navigate to the existing user account.
10. Click the accessibility icon to open a terminal with admin rights.
11. Use "ez-add-user.bat" to create a new "Admin" account with the password "1234".

## 🧹 Additional Commands

- To delete the user, use "remove-user.bat".
- To revert all changes, use "restore.bat".

## ⚠️ Disclaimer

`dan-admin` is intended for educational purposes only. Any misuse can result in criminal charges. The authors are not responsible for any damage caused by the misuse of this tool.
