#!/bin/zsh

nudgeLaunchAgentPath="/Library/LaunchAgents/com.github.macadmins.Nudge.plist"
nudgeAppPath="/Applications/Utilities/Nudge.app"

loggedInUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
userID=$(/usr/bin/id "${loggedInUser}" | /usr/bin/awk '{print $1}' | /usr/bin/sed 's/[=()a-zA-Z]//g')

if /bin/launchctl asuser "$userID" /bin/launchctl list com.github.macadmins.Nudge ; then
    echo "Launch agent running under signed in user, unloading it."
    /bin/launchctl asuser "$userID" /bin/launchctl unload /Library/LaunchAgents/com.github.macadmins.Nudge.plist
else
    echo "Launch agent not running."
fi

if [[ -e $nudgeLaunchAgentPath ]]; then
    echo "Removing launch agent plist."
    /bin/rm $nudgeLaunchAgentPath
    /bin/sleep 1
else
    echo "No launch agent found."
fi

if [[ -e $nudgeAppPath ]]; then
    echo "Removing App agent plist."
    /bin/rm -r $nudgeAppPath
else
    echo "No App agent found."
fi
