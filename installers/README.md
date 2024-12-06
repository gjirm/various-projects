# Run test container

Build:

```shell
docker built -t myubuntu .
```

Run:

```shell
docker run --rm -it -v ${pwd}:/data myubuntu
```
