# PSScanner

PSScanner is made for IT administrators to scan corporate network, showing IP address, hostname, current logon user and serialnumber for all connected computers.
It is a WPF application written in Powershell; it depents on PSParallel module for multi-threaded scan.

Featuring ICMP scan and ARP scan, PSScanner can scan the whole network in a few minutes.

Logon user query method: Reverse DNS resolution

Serial number query: WMI remote query. RPC needs to be running on each target otherwise the result will be "...". Domain admin right required.

Arp clear cache: Local admin right required.

This project can be a template for any Powershell/WPF application development.

1) RunspacePool management
2) Passing data from worker threads to UI thread, the best way is using dispatcher timer, rather than dispatcher invoke which freezes the UI.
3) A good producer/consumer model implementation using Concurrent Queue Collection from .Net, it is thread safe.
4) Utilizing Mutex to protect shared variables
5) Designing UI by directly editing xaml file, no UI designer software required (Visual Studio, etc.)

Files:

PSScanner.ps1  : Requires Windows Powershell 5.0 up with PSParallel module installed

Contributions : Pull requests and/or suggestions are more than welcome via email: support@mecro.ca

Screenshot:
![image](https://user-images.githubusercontent.com/57880343/114135249-d41f6400-98bd-11eb-90d7-89b1da6fb461.png)
Due to scanning WAN IP, this screenshot only shows IP address.
