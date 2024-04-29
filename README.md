# RPGMaker VX Ace AP
 Scripts that allow RPGMaker VX Ace, using mkxp-z, to connect to the Archipelago Multiworld Randomizer
 *Note: This readme is in a todo state but WILL be improved later*

 ## Usage
 1. Replace your RPGMaker game's executable with [mkxp-z](https://github.com/mkxp-z/mkxp-z), either by building it yourself or using an automatic build.
 2. Copy and paste the "Ruby" folder and "mkxp.json" into the game directory.
 3. Add the contents of Archipelago_RGSS3 to your game's Scripts. (Script Editor -> Insert new script -> Paste Archipelago_RGSS3's contents into that new script)
 4. Configure the script under the CONFIGURATION section within it.

Your game will now be able to receive ReceiveItem packets from Archipelago!

## Notes
`$archipelago` is your client. All Archipelago-related methods must use it.
Call `$archipelago.connect` to connect to the multiworld
All other methods/accessors are almost identical to the ones provided by [archipelago.js](https://thephar.github.io/Archipelago.JS/)

Feel free to message me (Discord: eggslashether) or email me (archipelago_rb@eggslashether.com) if you have any issues! I'm always willing to help.
