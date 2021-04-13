# PSScanner

PSScanner is made for IT administrators to scan corporate network, showing IP address, hostname, current logon user and serialnumber for all connected computers.
It is a WPF application written in Powershell; it depents on PSParallel module for multi-threaded scan.

Featuring ICMP scan and ARP scan, PSScanner can scan the whole network in a few minutes.

Logon user and serial number: Run the script with an elevated domain admin account which has admin right on all domain computers.

Files:

PSScanner.ps1  : Requires Windows Powershell 5.0 up with PSParallel module installed

PSScanner7.ps1 : Requires Powershell Core 7.0 up with ForEach-Object -Parallel supported

Contributions : Pull requests and/or suggestions are more than welcome via email: support@mecro.ca

Screenshot:
![image](https://user-images.githubusercontent.com/57880343/114135249-d41f6400-98bd-11eb-90d7-89b1da6fb461.png)
Due to scanning WAN IP, this screenshot only shows IP address.
