              ggg
         ,,eee$$$  ,,aaa,.  $$$eea,.
        $$$`` $$% $$$```$$$ $$$``$$$l
        $$$---$$$ $$$---$$$ $$$---$$$
        $$$ � $$$ $$$ � $$$ $$$ �� ..
        $$$---$$$ $$$---$$' $$$------
        `$$a.a$$$ $$$ "$P'  $$$
                  $$$

]==================[.dPR.]=================[
    Mystic 2-Factor Authenticator [MPY]
]==========================================[
  * Add 2-Factor One-Time Password Auth
  * Creates TOTP QR Code ANSIs on Your BBS
  * Compatiable With Any TOTP Apps:
    Authy/Microsoft/Google Authenticators
  * For Mystic 1.12 A43+
]==========================================[

                         .dPR. 2-Factor Authenticator
                                  .v0.31.

 --------------------------------[Install]---------------------------------
 1. Ensure your clock is in sync with NIST timeservers!!! If it
    is not in sync, even off a few seconds, the use experience may
    be degraded. You can quickly check the BBS clock against:

              https://timegov.nist.gov/

    You can set your system clock to the following timeserver:

              time.nist.gov

    Or any on NIST's website:

              https://tf.nist.gov/tf-cgi/servers.cgi

    NOTE: Failure to synchronize to global internet time will cause
    TOTP failures during the out of sync phases. TOTP use 30 second
    intervals. Additionally, ensure your timezone is setup
    accordingly. See dpr_2fa.mpy header for notes on setting
    timeserver polling interval.

 2. Install the MPY script (scripts folder) to your Mystic BBS
    scripts directory.
    This script contains all the calls to enable/disable/validate
    user's 2-Factor Authentication via Time-based One Time Password

    Install the ansi (text folder) to your Mystic BBS text
    directory.

    NOTE: This script uses Mystic's Optional User Field 3 to save
    the Secret TOTP key. It can be modified to use any of the
    optional user fields by changing all MCI U3 references in the
    script and menu commands below. If you are using all three
    optional user fields, this script will not work as built.

    * Copy dpr_2fa.mpy to your Mystic scripts directory.
    * Edit dpr_2fa.mpy, the following variables are configurable:
      - OTP_USER_FLAG: Default set to 'O'. If a different flag is desired
                       change it here and in the Access strings for the
                       (Step 3) menu commands.
      - hangup: Set to True to hangup after user fails to validate. Set to
        False for debugging or testing or your needs.
      - allow_local_bypass: Set to True to allow local logins to skip
                            2FA validation.
      - local_ip_slice: Change this string to your IP from the local
                        machine or use part of your IP to allow anything
                        on your home/LAN network to skip 2FA validation.
      - bbs_name: Change this to your bbs name.
      - sysop_name: Change this to your sysop's handle/name.
      - valansi: This flag indicates whether to use the ANSI validation
                 routine or not. If set to True, it will load the otp_ans
                 file and take input using the 2-FA user interface.
                 If set to False, it will only use a text input block.
      - debug: This flag will enable debugging mode which allows for
               pressing ESCAPE to exit 2-FA for ANSI validation. When True,
               it will indicated debug mode at the validation screen.

    * Copy otp_ans.ans to you Mystic text directory.

 3. Install PIP packages for python required to run

    * From the command line, pip install the following packages:
               pip install pyotp
               pip install qrcode[pil]

 4. Setup the Mystic Menu commands
    These commands will provide the calls to the 2FA routines
    There are 4 total (3 required, 1 optional) modifications that
    need to be made.

    * Setup Account menu options:
      - Add a menu item to Enable 2FA:
        . Display Text: (@) 2-Factor Auth -> Disabled
        . Access: sXX!FO, NOTE: Here the XX is the allowable access level
                  you want a user to be able to access. !FO means that
                  the user DOES NOT have 2FA enabled via flag 'O'. If you
                  need a different flag, change it in the script header
                  also.
        . Hotkey: @
        . Display Type: Access
        . Command: (GY) Execute Python Module
        . Data: dpr_2fa --enable

      - Add a menu item to Disable 2FA:
        . Display Text: (!) 2-Factor Auth -> Enabled
        . Access: sXXFO, See Access above for notes. Ensure you use the
                  same flag.
        . Hotkey: !
        . Display Type: Access
        . Command: (GY) Execute Python Module
        . Data: dpr_2fa --disable

      - (Optional) Add a menu item to show Secret key for debugging:
        . Display Text: 2-Factor Auth Secret -> |U3
        . Access: sXX for users to see, but s255 recommended for Sysops
                  only.
        . Hotkey: NONE
        . Display Type: Access
        . Command: NONE

    * Setup PRELOGIN validation:
      - On the PRELOGIN menu that fires after User/Pass authentication and
        before any subsequent menus (your setup may be different), add the
        following FIRSTCMD items at the top of the list:
        . Command 1: (GY) Execture Python Module
        . Data: dpr_2fa --validate
        . Access: sXXFO

        . Command 2: (GY) Execture Python Module
        . Data: dpr_2fa --enable
        . Access: sXX!FO

        The first command will 2-FA validate if a user has access sXX and
        flag 'O' set. The second command will ask to enable 2-FA if the
        user does not have flag 'O' set. These are mutually exclusive so
        only one will fire. Don't forget to replace XX with the proper
        access level!

 ----------------------------------[.dPR.]---------------------------------
    Complete open source. It is yours to use and distribute as you want.
                          Hack it/use it/steal it!

 ------------------------------[Contact .dPR.]-----------------------------
 email: dpr@deadbeatz.org                          distro: deadbeatz.org:23
SAUCE00                                   Anonymous                               20200223y   L �      IBM VGA               