# Emacs Developer Image
I've been using emacs forever.  I like to run emacs in a Ubuntu 18.04 container under Windows
better than I like running WSL.  The result is this container.  Normally, a container should do 
just one thing and do it well.  This is a large deviation from that since I puts almost every
package that I usually install onto a Linux box into this container.  It's really a container
WSH more than a normal container.

## Running the Image

First create a volume for /home:

`docker volume create devhome`

Then run the container using that volume:

`docker run -v devhome:/home  --expose 6000 --expose 2375  emacs-developer`

