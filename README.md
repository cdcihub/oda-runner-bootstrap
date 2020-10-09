# ODA Runner Bootstrap

You need to get API token, and store it in ~/.dda-token.

To sync only modules and test connection:

```bash
export ODA_LOCAL_DATA=your-local-1Tb-location
SYNC=python-modules ./runner.sh container run
```



To sync semi-permanent data (leaving the default):

```bash
export ODA_LOCAL_DATA=your-local-1Tb-location
./runner.sh container run
```
