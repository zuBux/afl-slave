FROM ubuntu:precise

#Install essential packages
RUN apt-get update && apt-get -y install build-essential gcc g++ wget tar gzip make git gdb

# Download and install afl
RUN wget 'http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz' -O- | tar zxvf - && cd afl-* && make PREFIX=/usr install

# Install Crashwalk and dependencies
RUN wget https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.5.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN mkdir go
ENV GOPATH=/go
WORKDIR /go
RUN go get -u github.com/bnagy/crashwalk/cmd/...

# Export required environmental variables
ENV CC=afl-gcc
ENV CXX=afl-g++
ENV AFL_HARDEN=1
ENV AFL_SKIP_CPUFREQ=1
ENV AFL_EXIT_WHEN_DONE=1

VOLUME ["/output","/testcases"]
