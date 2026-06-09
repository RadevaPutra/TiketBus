#!/bin/bash
set -e
# Script to build Flutter web on Vercel

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Checking Flutter version..."
flutter --version

echo "Enabling web..."
flutter config --enable-web

echo "Getting dependencies..."
flutter pub get

echo "Building Flutter Web..."
flutter build web --release

echo "Build process completed!"
