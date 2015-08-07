Dockerflix
========

Want to watch U.S. Netflix, Hulu, MTV, Vevo, Crackle, ABC, NBC, PBS, HBO...?  
Got a Dnsmasq capable router at home, a Raspberry Pi or similar Linux computer?  
Got a virtual private server with a U.S. IP address?  
**Then you've come to the right place!**

Simply said, Dockerflix emulates what companies like Unblock-Us and the like have been doing for years.
Dockerflix uses a man-in-the-middle approach to reroute certain requests through a (your) server in the U.S. and thus tricks geo-fenced on-demand streaming media providers into thinking the request originated from within the U.S. 
This so-called DNS unblocking approach differs vastly from a VPN.

Since my [other  DNS unblocking project](https://github.com/trick77/tunlr-style-dns-unblocking) wasn't easy to install and hard to maintain, I came up with a new variant using [dlundquist's](https://github.com/dlundquist) [sniproxy](https://github.com/dlundquist/sniproxy) instead of HAProxy. 
To make the installation a breeze, I boxed the proxy into a Docker container and wrote a small, Python-based Dnsmasq configuration generator. And voilà: DNS-unblocking as a service (DAAS) ;-)

Thanks to sniproxy's ability to proxy requests based on a wildcard/regex match it's now so much easier to add support for a service. 
Now it's usually enough to just add the main domain name to the proxy and DNS configuration and Dockerflix will be able to hop the geo-fence in most cases.
Since most on-demand streaming media providers are using an off-domain CDN for the video stream, only web site traffic gets sent through Dockerflix. A few exceptions may apply though, notably if the stream itself is geo-fenced.

## Docker installation

This will install the latest Docker version on Ubuntu 12.04 LTS and 14.04 LTS:

`wget -qO- https://get.docker.io/gpg | sudo apt-key add -`  
`echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list`  
`apt-get update`  
`apt-get install lxc-docker`  

## Dockerflix container installation

Clone this Github repository on your VPS server and build the Dockerflix image:
 `docker build -t dockerflix .`

## Usage

Once the Dockerflix image has been built, just run it using:  
`docker run -d -p 80:80 -p 443:443 --restart=always --name dockerflix dockerflix`

Make sure TCP ports 80 and 443 on your VPS are not in use by some other software like a pre-installed web server. Check with `netstat -tulpn` when in doubt. Make sure both ports are accessible from the outside if using an inbound firewall on the VPS server.

From now on, the Dockerflix container can be resumed or suspended using `docker start dockerflix` and `docker stop dockerflix`

To see if the Dockerflix container is up and running use `docker ps` or `docker ps -a`. Want to get rid of Dockerflix? Just type `docker stop dockerflix; docker rm dockerflix` and it's gone. 

## Limitations

Dockerflix only handles requests using plain HTTP or TLS using the SNI extension. Some media players don't support SNI and thus won't work with Dockerflix. 
If you need to proxy plain old SSLv1/v2 for a device, have a look at the non-SNI approach in [tunlr-style-dns-unblocking](https://github.com/trick77/tunlr-style-dns-unblocking).
A few media players (i.e. Chromecast) ignore your DNS settings and always resort to a pre-configured DNS resolver which can't be changed (it still can be done though by rerouting these requests using iptables).
