@ECHO OFF
SET MYPATH=%~dp0
IF EXIST %MYPATH%bulk_copy_errors.log del /F %MYPATH%bulk_copy_errors.log
mysql_config_editor.exe remove --login-path=wb_migration_source 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
mysql_config_editor.exe set --login-path=wb_migration_source -h127.0.0.1 -P3306 -uroot -p 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
SET command=mysql.exe -h127.0.0.1 -P3306 -uroot -p -s -N information_schema -e "SELECT Variable_Value FROM GLOBAL_VARIABLES WHERE Variable_Name = 'datadir'" 2>> "%MYPATH%bulk_copy_errors.log"
FOR /F "tokens=* USEBACKQ" %%F IN (`%command%`) DO (
    SET DADADIR=%%F
)
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
pushd %DADADIR%
echo [0 %%] Creating directory dump_image_board
mkdir dump_image_board
pushd dump_image_board
copy NUL import_image_board.sql
echo SET SESSION UNIQUE_CHECKS=0; >> import_image_board.sql
echo SET SESSION FOREIGN_KEY_CHECKS=0; >> import_image_board.sql
echo use image_board_m; >> import_image_board.sql
echo [10 %%] Start dumping tables
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board category --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename category.txt category.csv
del category.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/category.csv' INTO TABLE category FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [20 %%] Dumped table category
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board commentary --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename commentary.txt commentary.csv
del commentary.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/commentary.csv' INTO TABLE commentary FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [30 %%] Dumped table commentary
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board content --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename content.txt content.csv
del content.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/content.csv' INTO TABLE content FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [40 %%] Dumped table content
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board meta --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename meta.txt meta.csv
del meta.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/meta.csv' INTO TABLE meta FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [50 %%] Dumped table meta
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board post --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename post.txt post.csv
del post.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/post.csv' INTO TABLE post FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [60 %%] Dumped table post
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board score --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename score.txt score.csv
del score.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/score.csv' INTO TABLE score FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [70 %%] Dumped table score
mysqldump.exe --login-path=wb_migration_source -t --tab=. image_board user --fields-terminated-by=, 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
rename user.txt user.csv
del user.sql
echo LOAD DATA INFILE 'image_board_m_#####_import/user.csv' INTO TABLE user FIELDS TERMINATED BY ',' ENCLOSED BY ''; >> import_image_board.sql
echo [80 %%] Dumped table user
copy NUL import_image_board.cmd
(echo @ECHO OFF) >> import_image_board.cmd
(echo echo Started load data. Please wait.) >> import_image_board.cmd
(echo SET MYPATH=%%~dp0) >> import_image_board.cmd
(echo IF EXIST %%MYPATH%%import_errors.log del /F %%MYPATH%%import_errors.log) >> import_image_board.cmd
(echo SET command=mysql.exe -h127.0.0.1 -P3306 -uroot -p -s -N information_schema -e "SELECT Variable_Value FROM GLOBAL_VARIABLES WHERE Variable_Name = 'datadir'" 2^>^> %%MYPATH%%import_errors.log) >> import_image_board.cmd
(echo FOR /F "tokens=* USEBACKQ" %%%%F IN ^(^`%%command%%^`^) DO ^() >> import_image_board.cmd
(echo     SET DADADIR=%%%%F) >> import_image_board.cmd
(echo ^)) >> import_image_board.cmd
(echo if %%ERRORLEVEL%% GEQ 1 ^() >> import_image_board.cmd
(echo     echo Script has failed. See the log file for details.) >> import_image_board.cmd
(echo     exit /b 1) >> import_image_board.cmd
(echo ^)) >> import_image_board.cmd
(echo pushd %%DADADIR%%) >> import_image_board.cmd
(echo mkdir image_board_m_#####_import) >> import_image_board.cmd
(echo xcopy %%MYPATH%%*.csv image_board_m_#####_import\* 2^>^> %%MYPATH%%import_errors.log) >> import_image_board.cmd
(echo if %%ERRORLEVEL%% GEQ 1 ^() >> import_image_board.cmd
(echo     echo Script has failed. See the log file for details.) >> import_image_board.cmd
(echo     exit /b 1) >> import_image_board.cmd
(echo ^)) >> import_image_board.cmd
(echo xcopy %%MYPATH%%*.sql image_board_m_#####_import\* 2^>^> %%MYPATH%%import_errors.log) >> import_image_board.cmd
(echo if %%ERRORLEVEL%% GEQ 1 ^() >> import_image_board.cmd
(echo     echo Script has failed. See the log file for details.) >> import_image_board.cmd
(echo     exit /b 1) >> import_image_board.cmd
(echo ^)) >> import_image_board.cmd
(echo mysql.exe -h127.0.0.1 -P3306 -uroot -p ^< image_board_m_#####_import\import_image_board.sql 2^>^> %%MYPATH%%import_errors.log) >> import_image_board.cmd
(echo if %%ERRORLEVEL%% GEQ 1 ^() >> import_image_board.cmd
(echo     echo Script has failed. See the log file for details.) >> import_image_board.cmd
(echo     exit /b 1) >> import_image_board.cmd
(echo ^)) >> import_image_board.cmd
(echo rmdir image_board_m_#####_import /s /q) >> import_image_board.cmd
(echo echo Finished load data) >> import_image_board.cmd
(echo popd) >> import_image_board.cmd
(echo pause) >> import_image_board.cmd
echo [90 %%] Generated import script import_image_board.cmd
popd
set TEMPDIR=%DADADIR%dump_image_board
echo Set fso = CreateObject("Scripting.FileSystemObject") > _zipIt.vbs
echo InputFolder = fso.GetAbsolutePathName(WScript.Arguments.Item(0)) >> _zipIt.vbs
echo ZipFile = fso.GetAbsolutePathName(WScript.Arguments.Item(1)) >> _zipIt.vbs
echo CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" ^& Chr(5) ^& Chr(6) ^& String(18, vbNullChar) >> _zipIt.vbs
echo Set objShell = CreateObject("Shell.Application") >> _zipIt.vbs
echo Set source = objShell.NameSpace(InputFolder).Items >> _zipIt.vbs
echo objShell.NameSpace(ZipFile).CopyHere(source) >> _zipIt.vbs
echo Do Until objShell.NameSpace( ZipFile ).Items.Count ^= objShell.NameSpace( InputFolder ).Items.Count >> _zipIt.vbs
echo wScript.Sleep 200 >> _zipIt.vbs
echo Loop >> _zipIt.vbs
CScript  _zipIt.vbs  "%TEMPDIR%"  "%DADADIR%dump_image_board.zip" 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
echo [100 %%] Zipped all files to dump_image_board.zip file
xcopy dump_image_board.zip %MYPATH% 2>> "%MYPATH%bulk_copy_errors.log"
if %ERRORLEVEL% GEQ 1 (
    echo Script has failed. See the log file for details.
    exit /b 1
)
del dump_image_board.zip
del _zipIt.vbs
del /F /Q dump_image_board\*.*
rmdir dump_image_board
popd
echo Now you can copy %MYPATH%dump_image_board.zip file to the target server and run the import script.
pause
