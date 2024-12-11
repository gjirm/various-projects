# My personal installer scripts

There are installer scripts for apps I use to quickly install latest versions from GitHub.

There are several folders containing scripts for different OS's:

- `x` - Linux
- `w` - Windows

## Run test container

Build:

```shell
docker build -t myubuntu .
```

Run:

```powershell
docker run --rm -it -v ${pwd}:/data myubuntu
```
