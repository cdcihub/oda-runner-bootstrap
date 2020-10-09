# ODA Runner Bootstrap

You need to get API token, and store it in ~/.dda-token.

Sync only modules:

```bash
export ODA_LOCAL_DATA=your-local-1Tb-location
./runner.sh container run sync-python-modules
```

Sync all, including semi-permanent data (can be skipped for a first test):

```bash
./runner.sh container run sync-all
```

Self-test the enviroment:

```bash
./runner.sh container run self-test
```

Wait for 3 tasks in a row, execute interactively:

```bash
./runner.sh container run oda-runner-execute -B 3
```

