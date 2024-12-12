# Scoop Setup

![Status of buckets](https://github.com/winpax/scoop-setup/actions/workflows/buckets.yml/badge.svg?event=schedule)
![Status of default usage](https://github.com/winpax/scoop-setup/actions/workflows/default_usage.yml/badge.svg?event=schedule)
![Status of install apps](https://github.com/winpax/scoop-setup/actions/workflows/install_apps.yml/badge.svg?event=schedule)
![Status of obsoleted parameters](https://github.com/winpax/scoop-setup/actions/workflows/obsoleted_parameters.yml/badge.svg?event=schedule)
![Status of run as admin](https://github.com/winpax/scoop-setup/actions/workflows/run_as_admin.yml/badge.svg?event=schedule)
![Status of update path](https://github.com/winpax/scoop-setup/actions/workflows/update_path.yml/badge.svg?event=schedule)

- `scoop-setup` action provides functions below
  - Install `scoop` to your Windows runner
  - Update `PATH` environment variable
  - Install applications with `scoop`

## Example

- If you want to install "sfsu" and "trunk", put codes like this into your workflow YAML

```yaml
- uses: winpax/scoop-setup@v1.0.0
  with:
    buckets: extras
    apps: sfsu trunk
```

## Supported environments

- `windows-latest`
- `windows-2019`

## Parameters

- Parameters can be specified by `with:` like this

```yaml
with:
  buckets: extras
  checkup: "true"
```

### `install_scoop`

- If `true` (default), `scoop` will be installed
- If `false`, `scoop` will not be installed
  - For example, if scoop was restored from cache, you can skip installation

### `run_as_admin`

- If `true` (default), `scoop` will be installed with `-RunAsAdmin`
  - Windows Runners provided by GitHub may need this, because currently they run with Administrator privilege

### `buckets`

- Specify bucket(s) to add
  - Delimit several buckets by white space like as `extras nonportable games`
  - Bucket(s) specified by this parameter must be "known" buckets, you can confirm them by `scoop bucket known` command
- This parameter is optional, no extra buckets will be added if omitted

### `apps`

- Specify application(s) to add
  - Multiple applications should be delimited by white space (e.g `sfsu trunk`)
- This parameter is optional, no applications will be installed if omitted

### `update`

- If `true` (default), `scoop update` will be run after installation

### `checkup`

- If `true`, `scoop checkup` will be run after installation

### `update_path`

- If `true` (default), path to `scoop` will be added to the `PATH` environment variable

## Advanced usage

### Sample to improve workflow performance with `actions/cache`

- If cache is available, `install_scoop` should be `false` to skip installation
- Include `packages_to_install` into cache seed to validate cache is including enough apps or not
- Increment `cache_version` if cache should be expired without changing `packages_to_install`

```yaml
env:
  packages_to_install: shellcheck
  cache_version: v0
  cache_hash_seed_file_path: "./.github/workflows/cache_seed_file_for_scoop.txt"
```

(snipped)

```yaml
jobs:
  build:
    steps:
      - name: Create cache seed file
        run: echo ${{ env.packages_to_install }} >> ${{ env.cache_hash_seed_file_path }}

      - name: Restore cache if available
        id: restore_cache
        uses: actions/cache@v4
        with:
          path: ${{ matrix.to_cache_dir }}
          key: cache_version_${{ env.cache_version }}-${{ hashFiles(env.cache_hash_seed_file_path) }}

      - name: Install scoop (Windows)
        uses: winpax/scoop-setup@v1.0.0
        if: steps.restore_cache.outputs.cache-hit != 'true'
        with:
          install_scoop: "true"
          buckets: extras
          apps: ${{ env.packages_to_install }}
          update: "true"
          update_path: "true"

      - name: Setup scoop PATH (Windows)
        uses: winpax/scoop-setup@v1.0.0
        if: steps.restore_cache.outputs.cache-hit == 'true'
        with:
          install_scoop: "false"
          update: "false"
          update_path: "true"
```

**Made with 💗 by Juliette Cordor**

**Thanks to [Minoru Sekine](https://github.com/MinoruSekine) for creating the original `setup-scoop` action**
