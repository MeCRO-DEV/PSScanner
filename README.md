![psscanner](https://user-images.githubusercontent.com/57880343/115976871-26e85500-a527-11eb-82e4-b7d1b768056e.png)

PSScanner is made for IT administrators to scan corporate network, showing IP address, hostname, current logon user and serial number for all connected computers.
It is a WPF application written in Powershell.

Featuring ICMP scan and ARP scan, PSScanner can scan the whole network in a fast speed.

Logon user query method: Windows query command

Host name query method: Reverse DNS resolution

Serial number query: WMI remote query. RPC needs to be running on each target otherwise the result will be "...". Domain admin right required.

Arp clear cache: Local admin right required.

Port scan/sweep

Intergrated PS7+ native multi-threading with ForEach-Object -Parallel (-ps7 switch will turn it on. PSScanner7.ps1 is obsolete

This project can be a template for any Powershell/WPF application development.

1) RunspacePool management
2) Passing data from worker threads to UI thread, the best way is using dispatcher timer, rather than dispatcher invoke which freezes the UI.
3) A good producer/consumer model implementation using Concurrent Queue Collection from .Net, it is thread safe.
4) Utilizing Mutex to protect shared variables
5) Designing UI by directly editing xaml file, no UI designer software required (Visual Studio, etc.)
6) Handling custom defined events, passing data between different threads with Powershell engine events

Usage:

1) IP Address: Any IP in the target subnet (IPv4 Class A,B,C)
2) Subnet mask or CIDR of your choice. CIDR default to 24.(IPv4 Class A,B,C)
3) Runspace capacity: [1-128]. To control the degree of parallelism, i.e. the number of concurrent runspaces, use the -ThrottleLimit parameter as I call it Runspacepool capacity. Default value is 128.
4) Check "More" to show current logon user and serial number on each live node.
5) Check ARP to use ARP scan. This is limited to the local network as ARP is a layer-2 protocol. ARP-Scanning a network which differs from the one your computer is on will be resulting zero nodes alive. ARP scan will exclude the IP of your own computer on which this script is running.
6) ARP Ping delay [0-9ms]: Delay(ms) between 2 arp probes. I use UDP request for this type of probing. Default value is 2.
7) Clear ARP cache before scanning: For the most accurate result, please clear the cache so you woudn't get any disconnected nodes and won't miss any new nodes, because it only scans the IPs in the arp cache.
8) Output IP order is random due to concurrency, but it will be sorted and saved to c:\PSScanner once all worker threads completed.
9) To clear the output window, just press ESC key, or it will be automatically cleared when you press SCAN button again.
10) Even though it can scan IPv4 class A,B,C addresses, this tool is tageted on corperate LAN only, rather than WAN. Scanning /8 network will take long time.
11) To get the best result, it requires an elevated domain admin account to run.

Files:

PSScanner.ps1  : Requires Windows Powershell 5.0 up with PSParallel module installed

PSScanner7.ps1  : Requires Powershell Core 7.0 up, no dependent module required (Obsolete, please use PSScanner.ps1 with -ps7 switch)

Contributions : Pull requests and/or suggestions are more than welcome.

Screenshot:

![Capture](https://user-images.githubusercontent.com/57880343/115995007-53838780-a58e-11eb-98a3-dbe009c68a9c.PNG)
![Capture7](https://user-images.githubusercontent.com/57880343/115999428-89316c00-a5a0-11eb-9183-8f4d021cbb72.PNG)


Due to scanning WAN IP, this screenshot only shows IP address.

Sorted output file:

![sorted](https://user-images.githubusercontent.com/57880343/115995150-ede3cb00-a58e-11eb-97ac-6bcc9e8552ce.PNG)

Powershell multi-threading performance comparision:

PSParallel seems faster than ForEach-Object -Parallel. I have scanned a /16 network using both methods, PSparallel used 1:10:28.575 while ForEach-Object used 1:18:33.939. It's about 8 minutes difference.

---------------
![](https://komarev.com/ghpvc/?username=MeCRO-DEV&color=green)
![](http://mecro.net/psscanner.php)
