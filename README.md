[![](https://images.microbadger.com/badges/image/neilswinton/emacs-developer.svg)](https://microbadger.com/images/neilswinton/emacs-developer "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/neilswinton/emacs-developer.svg)](https://microbadger.com/images/neilswinton/emacs-developer "Get your own version badge on microbadger.com")

# Emacs Developer Image

I've been using emacs forever.  I like to run emacs in a Ubuntu 18.04 container under Windows
better than I like running WSL.  The result is this container.  Normally, a container should do
just one thing and do it well.  This is a large deviation from that since I puts almost every
package that I usually install onto a Linux box into this container.  It's really a container
WSH more than a normal container.

## Running the Image

You'll need an X-Windows server.  Under Windows 10, I use [xming](https://sourceforge.net/projects/xming/) which I install using `chocolatey`.  On a Mac,
I used to use XQuartz.

First create a volume for /home:

`docker volume create devhome`

Then run the container using that volume:

`docker run -v devhome:/home  --expose 6000 --expose 2375  emacs-developer`

You can use the docker-compose.yml to make this all easier and more automatic for a single instance.
