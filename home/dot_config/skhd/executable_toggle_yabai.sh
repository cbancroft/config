#!/usr/bin/env bash

if [ $1 -eq 0 ]; then
	defaults write com.apple.dock autohide -bool true
	killall Dock
	brew services start yabai
	brew services start sketchybar
else
	defaults write com.apple.dock autohide -bool false
	killall Dock
	brew services stop yabai
	brew services stop sketchybar
fi
