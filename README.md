<h1 style="display:flex;align-items:center;">
    <img src="assets/static/images/apothecary.png" width="48" style="margin-right:5px;" /> 
    <span style="font-family:fantasy;color:rgba(79, 40, 167, 0.75);">Apothecary</span>
</h1>

A simple, self-hosted Elixir package respository.

## Features
Apothecary supports the following features:
- [ X ] Upload multiple package versions of a single library
- [ X ] Upload documents for each version of a library contained in Apothecary
- [ X ] Search packages 
- [   ] Search documents

## Setup
Apothecary requires a few one-time steps to get running.

### Directory Structure
On your host machine, create a directory for Apothercary to store files.

```bash
$ cd /path/where/you/want/apothecary/files/to/live
$ mkdir -p apothercary/public
$ tree .
.
└── apothecary
    └── public

2 directories, 0 files
```
> By default, Apothercary will look for `/apothecary` as a root directory, but you can supply a custom path and directory by setting `APOTHECARY_DIRECTORY`. In either case, the directory must contain a `public/` directory at its top level. If you are running Apothecary as a Docker container, the Apothecary directory can live anywhere on the host system and simply be mounted at `/apothecary` inside the container without requiring any configuration changes.

### Private Key
A private key is used by Apothecary to sign packages and ensure integrity.

Inside the Apothecary directory, create a private key with the following command:
```bash
$ openssl genrsa -out private_key.pem
```
> If the key file is located in the top level of your Apothecary directory and named `private_key.pem`, it will be automatically picked up. Otherwise, you can supply the
path and filename by setting `APOTHECARY_PRIVATE_KEY`.

### Repository Name
By default, Apothecary will use `apothecary` as the repository name, which can be changed by setting `APOTHECARY_REPO_NAME`. The repository name is used in your `mix.exs` files to pull packages from Apothecary, i.e.:

```
defp deps() do
  {:foo_bar, "~> 1.0", repo: "apothecary"}
end
```

If you were to change the repository name to `acme`, i.e. `APOTHECARY_REPO_NAME=acme`:

```
defp deps() do
  {:foo_bar, "~> 1.0", repo: "acme"}
end
```

### Apothecary User
> This step only applies if you are running Apothecary as a Docker container.

The container runs as an `apothercary` user, which requires a matching user on the host system with read/write permissions to the Apothecary directory.

## Running
The examples below assume the Apothecary directory is setup at `/home/apothecary` on the host machine, containing a `public/` directory and a private key named `private_key.pem`:

```bash
$ cd /home/apothecary
$ tree .
.
├── private_key.pem
└── public

1 directory, 1 file
```
### Running Locally
```
$ APOTHECARY_DIRECTORY=/home/apothecary mix phx.server
```
### Docker Build and Run
```bash
$ docker build -t apothecary .
$ docker run -p 4000:4000 -v /home/apothecary:/apothecary apothecary:latest
```

## File Storage and Backups
Apothecary will write packages and docs to the `public` directory under the Apothecary directory. Packages are stored in `public/tarballs` and docs are stored in `public/docs`. While other files and directories will be created and changed whenever the registry is built, `tarballs` and `docs` are the only directories that need to be backed-up for the registry to be properly restored. The registry is rebuilt on startup and whenever packages are added, updated, or deleted, so there's no need to backup other data (although it won't hurt anything).

## Acknowledgements
[Dashbit](https://dashbit.co/blog/mix-hex-registry-build)
