README:

Created to get up and running a linux based virtual machine ,for lazarus development.

This for personal testing and development. No software is 100% perfect.
I assume, you know something of bat files, qemu and debian.

I recommend you check the bat file and make any changes you feel relavent.
You can not copy and paste from host to client.
Work arounds are use spice as a virtual remote desktop or
I prefer to use SSH in a terminal for host to the client changes.
A mount point for sharing a windows folder is also useful, but not covered here.
Please read up n qemu to get the best for your host device or emulated machines / distributions.

Prerequisites: 
  Windows 11
  Modern CPU, Tested on AMD RYZEN 5 7600.
  Qemu for windows binary . Found at: https://qemu.weilnetz.de/w64/ 


Install and launch:
  A windows bat file script with options and checks.
  You must place the script in a folder that you want the qemu machine to run from.
  
  Assumptions :
    The downloaded Debian 13 ISO will go to your current user Download folder.
    You want to create the virtual disk with qemu image in the same folder as the bat file.
        
  Initial Virtual Machine : 
    64bit cpu
    Virtual drive is 64GB qcow2.
    8GB RAM

  Not Implement , but ready:
    SSH client on windows host, use the terminal to log in.
    create a shared drive on windows to use in debian.
    Install of extra software. 

    
