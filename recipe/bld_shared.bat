:: cmd

:: Isolate the build.
mkdir build_shared
cd build_shared
if errorlevel 1 exit 1

:: Disable tests for cross-compilation (win-arm64) - they can't run on x64 host
:: and gen_emitter_test.cpp hits MSVC C1128 section limit without /bigobj
if "%CONDA_BUILD_CROSS_COMPILATION%"=="1" (
    set BUILD_TESTS=OFF
) else (
    set BUILD_TESTS=ON
)

:: Generate the build files.
cmake .. -G"Ninja" ^
    -DYAML_CPP_BUILD_TESTS=%BUILD_TESTS% ^
    -DYAML_BUILD_SHARED_LIBS=ON ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DYAML_CPP_INSTALL=ON

if errorlevel 1 exit 1

:: Build and install.
ninja install
if errorlevel 1 exit 1

:: Call author's tests (only if not cross-compiling).
if "%CONDA_BUILD_CROSS_COMPILATION%"=="1" (
    echo Skipping tests for cross-compilation build
) else (
    test\yaml-cpp-tests
    if errorlevel 1 exit 1
)

:: Success!
exit 0
