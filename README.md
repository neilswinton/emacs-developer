![Docker](https://github.com/neilswinton/emacs-developer/workflows/Docker/badge.svg)
[![](https://images.microbadger.com/badges/image/neilswinton/emacs-developer.svg)](https://microbadger.com/images/neilswinton/emacs-developer
"Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/neilswinton/emacs-developer.svg)](https://microbadger.com/images/neilswinton/emacs-developer
"Get your own version badge on microbadger.com")

# Emacs Developer Image

I've been using emacs forever.  I like to run emacs in a Ubuntu 18.04 container
under Windows better than I like running WSL.  The result is this container.
Usually, a container should do just one thing and do it well.  This is a large
deviation from that since I put almost every package that I usually install onto
a Linux box into this container.  It's really a container WSH more than a normal
container.

## Running the Image

You'll need an X-Windows server.  Under Windows 10, I use
[xming](https://sourceforge.net/projects/xming/) which I install using
`chocolatey`.  On a Mac, I used to use XQuartz.

First, create a volume for /home:

`docker volume create devhome`

Then run the container using that volume:

`docker run --detach --volume devhome:/home --expose 6000 --expose 2375 neilswinton/emacs-developer`

You can use the docker-compose.yml to make this all easier and more automatic
for a single instance.


export DOCKER_HOST=host.docker.internal:2375

### Timezones 

The image contains support for timezones, but its default timezone is UTC.  You
can easily set the right timezone in your .profile:

`export TZ="America/New_York"`

### Man Pages 

The image contains support for man pages using `dman` as its source of man
pages.  The dman script lives here on the Ubuntu man page site --
https://manpages.ubuntu.com/dman -- and reads the man pages using https.  The
script is sensitive to the settings of LANG, LOCALE, and LC_MESSAGES.  You can
lose your man pages by changing the language settings.  The default .emacs file
will change the value of `manual-program` to dman so that the emacs man command
works right.


### Docker Commands If you are running on Windows and want to use docker
commands, check the following:

1. Docker setting "Expose daemon on tcp://localhost:2375 without TLS" is true
2. Your .profile contains `export DOCKER_HOST=host.docker.internal:2375`

### Docker Commands on a Linux Host
I'll check the setup for Linux next time I'm running docker on Linux.  In
general, you can access docker by mapping the docker socket from the Linux host
directly into the container as shown below:

`docker run --detach --volume /var/run/docker.sock:/var/run/docker.sock --volume devhome:/home --expose 6000 --expose 2375 neilswinton/emacs-developer`



