docker build -t mc-loongarch64 .
docker run --rm -v "$(pwd)"/dist:/dist mc-loongarch64
ls -al "$(pwd)"/dist