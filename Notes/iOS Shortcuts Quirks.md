# iOS Shortcuts Quirks

## “Add to variable” vs. “Set to Variable”

In my experience, the "Add to variable" action is unreliable for appending text to strings; it seems to work to *create* a variable, but not actually for appends. However, "Set to variable" seems to be reliable, so a work-around is to set a whole bunch of variables and then use a "Text" action at the end of the workflow to assemble them as desired.

## Get Shortcuts to Show Up in the iOS Share Sheet After Reinstallation

For whatever reason, shortcuts created in the iOS Shortcuts app won’t show up in apps’ share sheets if you’ve uninstalled Shortcuts and then reinstall it. To solve this, simply reboot the device and then open up the Shortcuts app (no need to run anything, just open it once).
