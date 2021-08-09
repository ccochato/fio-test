FROM ubuntu
RUN apt-get update && apt-get install -y make gcc g++ git libaio-dev libaio1 zlib1g-dev && mkdir -p /iotest/work && chmod 777 /iotest/work
WORKDIR /tmp/build
RUN git clone https://github.com/axboe/fio.git
WORKDIR /tmp/build/fio
RUN ./configure && make && make install

WORKDIR /iotest/work
COPY seqread.fio /iotest/
VOLUME /iotest/work

ENTRYPOINT [ "fio" ]


