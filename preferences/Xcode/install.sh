#!/bin/sh

path="/Contents/Frameworks/IDEKit.framework/Resources/IDETextKeyBindingSet.plist"
json=`cat UserDefined.json`
xcodes=`find /Applications -maxdepth 1 -name "Xcode*.app" -type d`

echo "Xcodes found:"
for xcode in $xcodes; do
  echo $xcode$path
  plutil -replace "User Defined" -json "$json" $xcode$path
done

