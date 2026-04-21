IF not x%PKG_NAME:static=%==x%PKG_NAME% (
    set SHARED="OFF"
) ELSE (
    set SHARED="ON"
)

cmake -B build-%PKG_NAME% ^
    -G Ninja ^
    -D CMAKE_MSVC_RUNTIME_LIBRARY="MultiThreadedDLL" ^
    -D BUILD_SHARED_LIBS=%SHARED% ^
    -D YAML_BUILD_SHARED_LIBS=%SHARED% ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D YAML_CPP_BUILD_TESTS=ON ^
    -D YAML_MSVC_SHARED_RT=ON ^
    %CMAKE_ARGS%
if errorlevel 1 exit 1

cmake --build build-%PKG_NAME% --parallel %CPU_COUNT% --verbose
if errorlevel 1 exit 1

cmake --install build-%PKG_NAME%
if errorlevel 1 exit 1

:: Call author's tests.
build-%PKG_NAME%\test\yaml-cpp-tests
if errorlevel 1 exit 1

:: Success!
exit 0
