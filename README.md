# Valor project template

When using [Valor](https://github.com/valibre-org/valor) you'll be creating independent plugins executed by a runtime(`valor_bin` or `valor_web`),
following this template it becomes easy to compile and run your plugins for development and production environments.

> At the time of this writting Valor only supports **native** plugins which are compiled as dynamic rust libraries. Since the rust ABI is not stable 
the version of the rust compiler that builds the valor runtime and all your plugins should be the same, for this reason the template provides the
necessary boilerplate to automatically compile the runtime and plugins with the same compiler.

## Build and Run

The template provides a `Containerfile` that can build your project and bundle it in a ready to use container.
```bash
podman build -t api .
```
Now you can run your newly created container(with podman or docker)
```bash
podman run --rm api
```

During development you'll find more convinient to simply use the `Makefile`
```bash
make
```
This will build the runtime and plugins defined in the `plugins.json`
