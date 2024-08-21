
                                                                                
                  ▄▄▄▄▄    ▄       ▄▄▄▄▄▄▄   ▄▄▄▄▄  ▄▄▄▄▄   ▄▄▄▄▄▄▄  
                  ▓    ▀▄  █          ▓     ▓       ▓    ▒     ▓     
                  ▒     ▒  ▒          ▒     ▒       ▒    ░     ▒     
                  ░     ░  ░          ░     ░       ░▄▄▄▄▀     ░     
                  █ ▀▀▀▀▄  █          █     █       █    █     █     
                  ▓     ▓  ▓          ▓     ▓       ▓    ▓     ▓     
                  ▒     ▒  ▒          ▒     ▒       ▒    ▒     ▒     
                  ░▄▄▄▄▀   ░▄▄▄▄▄     ░      ▀▄▄▄▄  ░    ░     ░     
                                                                     
                                                      version 1.0
                                                            
    
    // About //
    
    BLTCRT is a python lib, based on the BearLibTerminal* library, to emulate
    a console/terminal like, environment for application developing on the
    terminal.
    
    BearLibTerminal is used to build Rogue-like games. BLTCRT expands its 
    usage to an easier way to write console-like programs. The names of the 
    functions are the same as in Mystic Python (MPY) and also my other lib.
    PyCrt (https://github.com/xqtr/pycrt). This way, writing apps/mods to any
    of these platforms is like using almost the same code, only a few changes
    are needed.
    
    Also, because BLTCRT and BearLibTerminal are written in Python, you can
    run an application made with it, in any modern system (Windows, Unix/Linux,
    RPi) that uses Python3 and has a GUI. BLTCRT and BearLibTerminal are cross
    platform libs.
    
    You can see a full written application using BLTCRT, by downloading the
    file tdfstudio2.zip from Another Droid BBS or any FSXnet, DOREnet, SCInet,
    affiliate BBS. This file contains an app that displays TheDrawFonts and
    also can manipulate the files.
    
    You can use any .TTF font and give your app the look of a DOS app or an 
    Amiga one. BearLibTerminal/BLTCRT supports Unicode characters and many 
    fonts are included in the ./fonts directory.
    
    
    *http://foo.wyrd.name/en:bearlibterminal
    
    // Installation //
    
    Uncompress the archive in a desired directory. Make sure you have 
    installed python3 and the following packages:
    
     [] bearlibterminal 
        http://foo.wyrd.name/en:bearlibterminal
        
        install by using pip:
        pip install bearlibterminal
    
    
    // Usage //
    
    Import the library, best in this way:
        
        import bltcrt as crt
    
    ...now you can use MPY-like / Pascal-like functions like:
    
      writexy()
      readkey()
      textcolor()
      textbackground()
      clrscr()
    
    ...and more.
    
    You can always use the BearLibTerminal object for more advanced things, 
    like using the mouse. At the git site of BearLibTerminal you will find
    some very good examples.
    
    BLTCRT is not a replacement of BearLibTerminal, it's just an encapsulation
    of it to a more MPY-ish/Pascal-ish way, for writing cross-platform (BBS,
    Linux Terminal, Windows/Linux GUI, RPi) utilities, apps, mods.
    
    
    // license //
    ------------------------------------------------------------------------
    GNU GPL v2
    ------------------------------------------------------------------------

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
    MA 02110-1301, USA.

        
    // contact //
    
    For bugs, help, improvements contact me at my BBS, Another Droid
    
    telnet: andr01d.zapto.org:9999
    ssh   : andr01d.zapto.org:8888
    
    or via email at: xqtr@gmx.com
    
    
        
