FROM centos:centos7.9.2009

WORKDIR /opt/monaco

# Fetch the Monaco Binary
RUN curl -s https://api.github.com/repos/dynatrace-oss/dynatrace-monitoring-as-code/releases/latest \
    | grep 'browser_download_url.*linux-amd64"' | cut -d : -f 2,3  | tr -d \" | xargs -n 1 curl -O -sSL -o monaco

# combine the following


# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
# COPY deps.ts .
# RUN deno cache deps.ts

# These steps will be re-run upon each file change in your working directory:
ADD . /bin
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache /bin/main.ts

CMD ["run", "--allow-net", "--allow-env", "/bin/main.ts"]
# All API Tokens need to be exposed via ENV VARs to this docker container they should be the same name as those specified in the environments.yml file

CMD [ "deno", "index.ts" ]


