Automatic Security Level Updater v0.2a by MeaTLoTioN


INSTALLATION:
=============

Copy the file sec_check.mps that is in the scripts/ folder into the main mystic scripts folder.
Copy the files sec_upgrade.[ans|asc] that are in the text/ folder into the main mystic text folder.
Change into the mystic scripts folder
Compile the script using './mplc sec_check.mps'

Now in the menu editor, I would suggest putting this in the prelogin menu and edit the FIRSTCMD option. Tab into the Command section and insert a new command just before the Go to main menu. It will be type (GX) Execute MPL Program and the data will just be sec_check


That's about it. Now whenever a user logs in, if they've called more than the default configured 20 times OR have posted more than 20 messages, they will automatically get upgraded to security level 20. If they're already at level 20 they will have to post 50 messages or more AND called 50 times or more in order to get an upgrade, but it's configurable in the script.


This is my first MPL script, I hope it works for you and you like it.

MeaTLoTioN

