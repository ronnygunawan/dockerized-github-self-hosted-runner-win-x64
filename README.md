# Dockerized Github Self-hosted Runner Win-x64

## Build

```
docker build --build-arg URL=https://github.com/your_organization --build-arg TOKEN=YOURTOKEN -t github-runner .
```

## Run

```
docker run -d github-runner
```