@echo off

setlocal enabledelayedexpansion

set /a comPortNum=0
set /a comPortBaud=115200

set "b_arg="
set "c_arg="
set "d_arg="

:parse_args
    if "%~1"=="" goto end_parse_args
    if "%~1"=="-b" (
        set "b_arg=%~2"
        shift
    ) else if "%~1"=="-c" (
        set "c_arg=%~2"
        shift
    ) else if "%~1"=="-d" (
        set "d_arg=debug"
    )
    shift
    goto parse_args

    :end_parse_args

    echo -b bitrate: !b_arg!
    echo -c comport: !c_arg!

    if "%b_arg%"=="" (
        echo "default Baud : %comPortBaud%"
    ) else (
        set /a comPortBaud=%b_arg%
    )

    if "%c_arg%"=="" (
        call :auto_detect_com
        goto main_func
    )
    
    set /a comPortNum=%c_arg%
    echo "mode COM%comPortNum% /STATUS"
    mode COM%comPortNum% /STATUS

    goto main_func
exit /b

:auto_detect_com
    set /a counter=1
    set /a getCom=0

    :while_loop
        mode COM%counter% /STATUS >nul 2>&1
        if %errorlevel%==0 (
            echo "Found COM%counter%"
            if %getCom%==0 (
                set /a getCom=%counter%
            )
            @REM goto loop_end
        )

        if %counter% LSS 50 (
            @REM echo 当前计数器值：%counter%
            set /a counter=%counter%+1
            goto while_loop
        )
    :loop_end

    if %getCom%==0 (
        echo "Get COM Failed"
    ) else (
        echo "Use COM%getCom% by default"
        set /a comPortNum=%getCom%
    )

exit /b


:main_func
    echo "===========Start COM%comPortNum% with Baud %comPortBaud%=========="
    @REM plink -v -serial COM%counter% -sercfg 921600,8,1,n,N
    echo "ss -com:%comPortNum% -baud:%comPortBaud%"
    if "%d_arg%"=="debug" (
        echo "===========debug only, not start=========="
        exit /b
    )
    ss -com:%comPortNum% -baud:%comPortBaud%
    exit /b



    

