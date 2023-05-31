@echo off
set "folder_path=%CD%"

for %%F in (%folder_path%\*.lst %folder_path%\*.log %folder_path%\*.lxi %folder_path%\*.gsp %folder_path%\*.CSV) do (
    del "%%F" /q
)

echo All files with 'lst', 'log', 'gsp', 'CSV' or 'lxi' extension have been deleted.

pause
