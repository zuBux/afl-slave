FROM ubuntu:precise
MAINTAINER Paris Zoumpouloglou <zubu@zubu.re>

#Install essential packages
RUN apt-get update && apt-get -y install build-essential gcc g++ wget tar gzip make git

# Download and install afl
RUN wget 'http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz' -O- | tar zxvf - && cd afl-* && make PREFIX=/usr install

# Export required environmental variables
ENV CC=afl-gcc
ENV CXX=afl-g++
ENV AFL_HARDEN=1
ENV AFL_SKIP_CPUFREQ=1
ENV AFL_EXIT_WHEN_DONE=1

VOLUME ["/output","/testcases"]
