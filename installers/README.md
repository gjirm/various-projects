# Run test container

Build:

```shell
docker build -t myubuntu .
```

Run:

```shell
docker run --rm -it -v ${pwd}:/data myubuntu
```
