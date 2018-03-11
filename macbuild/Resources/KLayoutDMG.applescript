-------------------------------------------------------------------------------------------------
(*
 * Template File:
 *  macbuild/Resources/template-KLayoutDMG.applescript
 *
 * Actual AppleScrip File to be generated:
 *  macbuild/Resources/KLayoutDMG.applescript
 *
 * Description:
 *  A template AppleScript to make a fancy DMG installer of KLayout
 *  (http://www.klayout.de/index.php) bundles.
 *  "makeDMG4mac.py" will read this template and generate the actual AppleScript to execute.
 *  Values to be found and replaced by "makeDMG4mac.py" are marked by ${KEYWORD}.
 *
 *  The background image was designed using Logoist2 (http://www.syniumsoftware.com/en/logoist)
 *  and exported to a PNG file of 1000 x 700 pix size.
 *-----------------------------------------------------------------------------------------------
 *  This is a derivative work of Ref. 2) below. Refer to "macbuild/LICENSE" file.
 *  Ref.
 *   1) https://el-tramo.be/guides/fancy-dmg/
 *   2) https://github.com/andreyvit/create-dmg.git
 *)
-------------------------------------------------------------------------------------------------
on run (volumeName) -- most likely, the volume name is "KLayout"
    tell application "Finder"
        tell disk (volumeName as string)
            -- [1] Open the volume
            open

            -- [2] Set the key coordinates and windows size
            --     The size of given background PNG image is 1000 x 700 pix
            --     ORGX       =   [50] pix
            --     ORGY       =  [100] pix
            --     WIN_WIDTH  = [1000] pix
            --     WIN_HEIGHT =  [700] pix
            set posMargin   to 50
            set negMargin   to 10
            set theTopLeftX to 50
            set theTopLeftY to 100
            set theWidth    to 1000
            set theHeight   to 700
            set theBottomRightX to (theTopLeftX + theWidth  + posMargin)
            set theBottomRightY to (theTopLeftY + theHeight + posMargin)

            -- [3] Set the full path to .DS_Store file
            set dotDSStore to "/Volumes/KLayout/.DS_Store"

            -- [4] Set global view options
            tell container window
                set current view to icon view
                set toolbar visible to false
                set statusbar visible to false
                set statusbar visible to false
                set bounds to {theTopLeftX, theTopLeftY, theBottomRightX, theBottomRightY}
                set position of every item to {theTopLeftX + 150, theTopLeftY + 350}
            end tell

            -- [5] Set icon view options
            set opts to the icon view options of container window
            tell opts
                set icon size to 80
                set text size to 16
                set arrangement to not arranged
            end tell

            -- [6] Set the background PNG image (1000 x 700 pix) file name stored
            set background picture of opts to file ".background:KLayoutDMG-Back.png"

            -- [7] Set positions of each icon
            --     ITEM_1 = klayout.app      {960, 140}
            --     ITEM_2 = klayout.scripts  {610, 140}
            --     ITEM_3 = Applications     {790, 140}
            set position of item "klayout.app" to {960, 140}
            set position of item "klayout.scripts" to {610, 140}
            set position of item "Applications" to {790, 140}

            -- [8] Update the contents of container
            close
            open
            update without registering applications

            -- [9] Force save the negatively resized window size
            delay 2
            tell container window
                set statusbar visible to false
                set bounds to {theTopLeftX, theTopLeftY, theBottomRightX - negMargin, theBottomRightY - negMargin}
            end tell
            update without registering applications
        end tell

        -- [10] Restore back the original window size
        delay 2
        tell disk (volumeName as string)
            tell container window
                set statusbar visible to false
                set bounds to {theTopLeftX, theTopLeftY, theBottomRightX, theBottomRightY}
            end tell
            update without registering applications
        end tell

        -- [11] Wait for some time so that "Finder" can complete writing to .DS_Store file
        delay 3
        set elapsedTime to 0
        set ejected to false
        repeat while ejected is false
            delay 1
            set elapsedTime to elapsedTime + 1
            if (do shell script "[ -f " & dotDSStore & " ]; echo $?") = "0" then set ejected to true
        end repeat
        log "### Elapsed <" & elapsedTime & "> [sec] for writing .DS_Store file."
    end tell
end run

--
-- End of file
--
