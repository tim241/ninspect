FROM debian:latest
COPY ["ftl", "/root/ftl/"]

# update & install dependencies
RUN apt-get update -y
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential lzop git zlib1g zlib1g-dev libusb-1.0-0-dev pkg-config cryptsetup

# Get tools
RUN git clone https://github.com/linux-sunxi/sunxi-tools /root/sunxi-tools

# Build tools
WORKDIR /root/sunxi-tools
RUN make

# Install
RUN make install

# Build decn
WORKDIR /root/ftl 
RUN make

# Copy scripts
COPY ["split_bootimg/", "/root/split_bootimg/"]
COPY ["scripts/", "/root/scripts/"]

# symlink scripts
RUN ln /root/scripts/copydata.sh /usr/bin/copydata
RUN ln /root/scripts/copygames.sh /usr/bin/copygames
RUN ln /root/scripts/decryptrootfs.sh /usr/bin/decryptrootfs
RUN ln /root/scripts/extractkeyfile.sh /usr/bin/extractkeyfile
RUN ln /root/scripts/extractpartitions.sh /usr/bin/extractpartitions
RUN ln /root/scripts/listpartitions.sh /usr/bin/listpartitions
RUN ln /root/scripts/mountnand.sh /usr/bin/mountnand
RUN ln /root/scripts/mountpartition.sh /usr/bin/mountpartition

# give scripts executable rights
RUN chmod +x /usr/bin/copydata /usr/bin/copygames /usr/bin/decryptrootfs /usr/bin/extractkeyfile /usr/bin/extractpartitions /usr/bin/listpartitions /usr/bin/mountnand /usr/bin/mountpartition

# Start bash in /dump
WORKDIR /dump
CMD ["/bin/bash", "-i", "-c", "mountnand; /bin/bash"]
