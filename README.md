# ODA Runner Bootstrap

You need to get API token, and store it in ~/.dda-token.

You will also need local storage space to share semi-permanent data and caches.

```bash
export ODA_LOCAL_DATA=your-local-1Tb-location
```

Sync python modules, test connection and environment:

```bash
./runner.sh container run sync-python-modules
./runner.sh container run self-test
```

Sync all, including semi-permanent data (can be skipped for a first test):

```bash
./runner.sh container run sync-all
```
Wait for 3 tasks in a row, execute interactively:

```bash
./runner.sh container run oda-runner-execute -B 3
```

Runners can be started in a long-living mode, e.g. in k8s (see also https://github.com/cdcihub/dda-chart).

But, it is also often necessary to deploy runners to an HPC cluster, if necesary. An example used in UNIGE Baobab cluster:

```bash
$ oda-node runner start-executor \
    'bash -c "export -n partition; export batch_time=00:10:00; seq 1 3 > jobs; bao-submit-array ../integral-oda-worker/ jobid jobs"'  \
    'bao-squeue'  \
```

where the first argument is the command to launch runners in job(s), and the second one lists the currently deployed runners (to limit their number).
