#!/bin/bash
PGE_WIN32ZIP="https://wohlsoft.ru/docs/_laboratory/_Builds/win32/bin-w32/_packed/pge-project-master-win32.zip"

echo "================================================"
echo "      Welcome to PGE Project update tool!"
echo "================================================"
echo "    Please, close Editor, Engine, Maintainer,"
echo "      and Calibrator until continue update"
echo "================================================"
echo "         To quit from this utility just"
echo "      close [x] this window or hit Ctrl+C"
echo ""
echo "Overwise, to begin update process, just"
echo "press any key..."
read -n 1


echo ""
echo ""
echo "* (1/4) Downloading..."
echo ""

if [ ! -d settings ]; then
    mkdir settings
fi

echo "- Downloading update for PGE toolchain..."
wget ${PGE_WIN32ZIP} -O "settings/pgezip.zip"
if [[ "$?" != "0" ]]; then
	echo "Failed to download ${PGE_WIN32ZIP}!"

	echo "Press any key to quit..."
	read -n 1
	exit 1
fi

echo "* (2/4) Extracting..."
unzip -o "settings/pgezip.zip" "PGE_Project/*" -d settings/PGE > /dev/null

echo "* (3/4) Copying..."
find settings/PGE/PGE_Project/ -name "*.exe" -exec chmod 755 {} \;
cp -a settings/PGE/PGE_Project/* .
if [[ "$?" != "0" ]]; then
	echo "======= ERROR! ======="
	echo "Some files can't be updated! Seems you still have opened some PGE applications"
	echo "Please close all of them and retry update again!"
	echo "======================"

	echo "Press any key to quit..."
	read -n 1
	exit 1
fi

echo "* (4/4) Clean-up..."
rm settings/pgezip.zip
rm -Rf settings/PGE

# Nuke useless themes are was added as examples
if [ -d "themes/Some Thing" ]; then rm -Rf "themes/Some Thing"; fi
if [ -d "themes/test" ]; then rm -Rf "themes/test"; fi
if [ -d "themes/pge_default" ]; then rm -Rf "themes/pge_default"; fi
if [ -f "themes/README.txt" ]; then rm "themes/README.txt"; fi

echo ""
echo "Everything has been completed! ===="

echo "Press any key to quit..."
read -n 1

exit 0

