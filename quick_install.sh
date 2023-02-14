# Quick install cmds for some of the tools i use
# for Linux & Windows
# raw: https://jirm.cz/qi

# Install Chocolatey
irm https://go.jirm.cz/ch | iex

# Install scoop package manager
irm https://get.scoop.sh | iex

# Install scoop package manager as admin
irm https://go.jirm.cz/scoopadmin | iex

# age (https://age-encryption.org)
curl -s https://go.jirm.cz/i/age.sh | bash
irm https://go.jirm.cz/i/age.ps1 | iex

# cosign (https://github.com/sigstore/cosign)
curl -s https://go.jirm.cz/i/cosign.sh | bash

# croc (https://github.com/schollz/croc)
curl -s https://go.jirm.cz/i/croc.sh | bash
irm https://go.jirm.cz/i/croc.ps1 | iex
irm https://go.jirm.cz/i/croc-get.ps1 | iex # only download latest

# ctop (https://github.com/bcicen/ctop)
curl -s https://go.jirm.cz/i/ctop.sh | bash

# ethr (https://github.com/microsoft/ethr)
curl -s https://go.jirm.cz/i/ethr.sh | bash
irm https://go.jirm.cz/i/ethr.ps1 | iex

# lf (https://github.com/gokcehan/lf)
curl -s https://go.jirm.cz/i/lf.sh | bash

# micro text editor (https://micro-editor.github.io/)
curl -s https://go.jirm.cz/i/micro.sh | bash
curl -s https://go.jirm.cz/i/micro-nightly.sh | bash
irm https://go.jirm.cz/i/micro.ps1 | iex

# minisign (https://jedisct1.github.io/minisign/)
curl -s https://go.jirm.cz/i/minisign.sh | bash
irm https://go.jirm.cz/i/minisign.ps1 | iex

# smallstep cli (https://smallstep.com/docs/step-cli)
curl -s https://go.jirm.cz/i/step.sh | bash
irm https://go.jirm.cz/i/step.ps1 | iex

# tigthvnc (https://www.tightvnc.com/)
irm https://go.jirm.cz/i/vnc.ps1 | iex

# webwormhole cli (https://github.com/gjirm/webwormhole/)
curl -s https://go.jirm.cz/i/ww.sh | bash
irm https://go.jirm.cz/i/ww.ps1 | iex
