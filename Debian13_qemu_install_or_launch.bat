@echo off
setlocal

title Qemu with Debian 13 on a Virtual Disk.
REM Windows Batch file to launch or Install QEMU Debian 13 desktop version Virtual Machine

REM *** During the Debian install, Select XFCE and ssh server for the desktop. ***
REM A seed CD ISO can be made to do the selections, mount a swap drive and install FPC and lazarus too. But not implement here.

REM Default to current directory, if not set.
if "%deb_DIR%"=="" (
    set "HOST_DIR=%~dp0"
) else (
    set "HOST_DIR=%deb_DIR%"
)
set "DISK_PATH=%HOST_DIR%"
set "VM_DISK=debian13_64.qcow2"

set "DOWNLOADS=%USERPROFILE%\Downloads"
set "DEBIAN_ISO=debian-13.7.0-amd64-netinst.iso"
set "LOCAL_ISO=%DOWNLOADS%\%DEBIAN_ISO%"

where curl >nul 2>&1
if errorlevel 1 (
    echo curl is not installed.
    exit /b 1
)

if not exist "%LOCAL_ISO%" (
    echo Debian ISO not found.
    echo Downloading...
    curl -L -o "%LOCAL_ISO%" https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"%DEBIAN_ISO%"
	if errorlevel 1 (
        echo Download failed.
        exit /b 1
    )
echo Download complete.
)


set "QEMU_PATH=C:\Program Files\qemu"
set "QEMU_EXE=%QEMU_PATH%\qemu-system-x86_64.exe"
set "QEMU_IMG=%QEMU_PATH%\qemu-img.exe"

where qemu-system-x86_64 >nul 2>&1

if not errorlevel 1 (
    for /F "delims=" %%i in ('where qemu-system-x86_64') do set "QEMU_EXE=%%i"
    for /F "delims=" %%i in ('where qemu-img') do set "QEMU_IMG=%%i"
)

if not exist "%QEMU_EXE%" (
    echo qemu-system-x86_64.exe not found.
    exit /b 1
)

if not exist "%QEMU_IMG%" (
    echo qemu-img.exe not found.
    exit /b 1
)

REM Set the common options for both install and launch 

REM Launch VM (virtio disk, virtio net, SSH port forward)
REM Gliches hangs:
REM   -display gtk
REM   -device qemu-xhci
REM   -cpu x86-64-v2
REM Performance work:
REM  -machine pc
REM  -machine q35
REM  -cpu qemu64
REM  -cpu host
REM  -cpu max
REM  -device ich9-usb-ehci1 
REM  p aka parameter.
set "p="
set "p=%p% -machine q35"
set "p=%p% -m 8192" 
set "p=%p% -cpu qemu64"
set "p=%p% -accel whpx"
set "p=%p% -smp cores=4,sockets=1"
set "p=%p% -netdev user,id=net0,hostfwd=tcp:0.0.0.0:2222-:22,smb=D:\Linux_share"
set "p=%p% -device virtio-net-pci,netdev=net0"
set "p=%p% -device ich9-usb-ehci1"
set "p=%p% -device usb-tablet"
set "p=%p% -vga std"
set "p=%p% -display sdl,gl=on"
set "p=%p% -drive if=virtio,file=""%DISK_PATH%%VM_DISK%"",format=qcow2"
set "COMMON_OPTS=%p%"

REM Reset p for install options
set "p="
set "p=%p% -cdrom ""%LOCAL_ISO%"" "
set "p=%p% -boot d"
set "INSTALL_OPTS=%p%"


REM Create 64GB QCOW2 disk if it doesn't exist.
REM If disk exists, Launch the VM
if not exist "%DISK_PATH%%VM_DISK%" (
    echo Qemu, Install %DEBIAN_ISO% on a new Virtual Disk.
	echo During the Debian install, select XFCE and SSH Server.
	choice /C YN /M "Install now?"
	REM errorlevel 2 = N = no = exit. Anything else, continue script.
	if errorlevel 2 exit /b 1		
    REM Create VM disk and install Debian onto it
    echo Creating 64GB QCOW2 disk...
    "%QEMU_IMG%" create -f qcow2 "%DISK_PATH%%VM_DISK%" 64G
    "%QEMU_EXE%" %COMMON_OPTS% %INSTALL_OPTS% 
) else (
    echo Disk already exists.
	REM Launch the Qemu debain VM 
	"%QEMU_EXE%" %COMMON_OPTS%
)

endlocal
