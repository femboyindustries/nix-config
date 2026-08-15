frp is the `ssh -R` replacement i've ended up going with. this supports both TCP
and UDP and should be easier and faster to use (and no longer require an SSH
key). you can still use `ssh -R`, but this is the recommended way to go

## usage

0. download [frp](https://github.com/fatedier/frp/releases)
1. settle on a port to use. currently, ports in the **48000 - 54000** range are
   open in the firewall and free to use for any purpose. ideally, use a random
   number generator to try and avoid collisions
    - there's not a limit on how many ports one person can use, but like,
      don't get ridiculous with it
2. create a config and put it wherever (i put mine in `~/.config/frp.toml`).
   here's a sample config:
    ```toml
    serverAddr = "51.83.161.40" # nanachi IP
    serverPort = 7000 # leave as-is

    auth.method = "token"
    auth.token = "$TOKEN"

    [[proxies]]
    name = "my-new-proxy" # whatever you want it to be
    type = "tcp" # can be tcp, udp, tcpmux
    localIP = "127.0.0.1"
    localPort = 7590 # port on your machine to forward
    remotePort = 29454 # your chosen port within 48k-54k range

    # you can add more proxies by duplicating the entire [[proxies]] block
    ```

    you want to replace `$TOKEN` with a token given to you by jade (or just `cat
    /etc/frp-token` if you have SSH access)

    check their [example
    config](https://github.com/fatedier/frp/blob/dev/conf/frpc_full_example.toml)
    for further info (note: we currently do not have HTTP properly setup, just
    use TCP instead)
3. run frpc
    ```sh
    frpc -c ~/.config/frp.toml
    ```

    you can add this a system service if you're regularly forwarding a port
    (nixos has a module for it, otherwise you can make a systemd module)