# PSScanner

PSScanner is made for IT administrators to scan corporate network, showing IP address, hostname, current logon user and serialnumber for all connected computers.
It is a WPF application written in Powershell; it depents on PSParallel module for multi-threaded scan.

Featuring ICMP scan and ARP scan, PSScanner can scan the whole network in a few minutes.

Logon user and serial number: Run the script with an elevated domain admin account which has admin right on all domain computers.

Contributions : Pull requests and/or suggestions are more than welcome.

Screenshot:
![image](https://user-images.githubusercontent.com/57880343/114135249-d41f6400-98bd-11eb-90d7-89b1da6fb461.png)
Due to scanning WAN IP, this screenshot only shows IP address.
