# Install Crew using Vagrant

- Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Download and install [Vagrant](http://www.vagrantup.com/downloads.html)
- Clone Crew

    ```
    git clone https://github.com/progrium/crew.git
    ```

- Setup SSH hosts in your `/etc/hosts`

    ```
    10.0.0.2 crew.me
    ```

- Create VM
    ```
    # Optional ENV arguments:
    # - `BOX_NAME`
    # - `BOX_URI`
    # - `BOX_MEMORY`
    # - `CREW_DOMAIN`
    # - `CREW_IP`
    # - `FORWARDED_PORT`.
    cd path/to/crew
    vagrant up
    ```
- Setup SSH Config in `~/.ssh/config`. The port listed here is usually correct, though you may want to verify that it is the same as the one listed in the output of `vagrant ssh-config crew`

    ```
    Host crew.me
        Port 22
    ```

- Copy your SSH key via `cat ~/.ssh/id_rsa.pub | pbcopy` and paste it into the crew-installer at http://crew.me . Change the `Hostname` field on the Crew Setup screen to your domain and then check the box that says `Use virtualhost naming`. Then click *Finish Setup* to install your key. You'll be directed to application deployment instructions from here.

You are now ready to deploy an app or install plugins.

For a different, complete, example see https://github.com/RyanBalfanz/crew-vagrant-example.
