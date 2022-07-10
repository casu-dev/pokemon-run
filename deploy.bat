Xcopy . "../Pokemon Battle Woods - v1" /E /H /C /I
echo "Removing Folders"
rmdir /s /q "../Pokemon Battle Woods - v1/.git"
rmdir /s /q "../Pokemon Battle Woods - v1/.idea"
del "../Pokemon Battle Woods - v1/.gitignore"
del "../Pokemon Battle Woods - v1/deploy.bat"
del "../Pokemon Battle Woods - v1/README.md"