
### Install RancherOS on Hetzner (or from initramfs other than RancherOS)

#### Notes

You may want to use the following aliases for SSH

_ssh-nocare-hostkey_ (try public keys (RancherOS rejects after too many keypair attempts))
```
ssh \
  -o PubkeyAuthentication=yes \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no
```


_ssh-nocare_ (do not use public key (when hetzner is in recovery/pxe-boot))
```
ssh \
  -o PubkeyAuthentication=no \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no
```


_run the line below_
```
curl https://raw.githubusercontent.com/hkeio/boot-rancheros-hetzner/master/run.sh > rancher.sh && chmod +x rancher.sh && ./rancher.sh
```

_after rebbot login with displayed credentials and run_

```
sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server
```
