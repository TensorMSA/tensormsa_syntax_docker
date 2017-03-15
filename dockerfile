FROM java:8

ENV SYNTAXNETDIR=/opt/tensorflow PATH=$PATH:/root/bin

RUN mkdir -p $SYNTAXNETDIR \
    && cd $SYNTAXNETDIR \
    && apt-get update \
    && apt-get install git zlib1g-dev file swig python2.7 python-dev python-pip python-mock -y \
    && pip install --upgrade pip \
    && pip install -U protobuf==3.0.0b2 \
    && pip install asciitree \
    && pip install numpy \
    && wget https://github.com/bazelbuild/bazel/releases/download/0.4.3/bazel-0.4.3-installer-linux-x86_64.sh \
    && chmod +x bazel-0.4.3-installer-linux-x86_64.sh \
    && ./bazel-0.4.3-installer-linux-x86_64.sh --user \
    && git clone --recursive https://github.com/tensorflow/models.git \
    && cd $SYNTAXNETDIR/models/syntaxnet/tensorflow \
    && echo -e "\n\n\n\n\n\n\n\n\n" | ./configure \
    && apt-get autoremove -y \
    && apt-get clean

RUN cd $SYNTAXNETDIR/models/syntaxnet \
    && bazel test --genrule_strategy=standalone syntaxnet/... util/utf8/...
	
RUN cd $SYNTAXNETDIR/models/syntaxnet \
    && git clone --recursive https://github.com/dsindex/syntaxnet.git work \

RUN cd $SYNTAXNETDIR/models/syntaxnet/work \
    && ./parser_trainer_test.sh
	
RUN mkdir -p $SYNTAXNETDIR/models/syntaxnet/work/corpus \
    && cd $SYNTAXNETDIR/models/syntaxnet/work/corpus \
    && wget --content-disposition 'https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11234/1-1548/ud-treebanks-v1.2.tgz?sequence=1&isAllowed=y' \
    && chmod +x ud-treebanks-v1.2.tgz \
    && tar xf ud-treebanks-v1.2.tgz \

RUN cd $SYNTAXNETDIR/models/syntaxnet/work \
    && ./train.sh -v -v \
    && ./train_p.sh -v -v \
    && ./sejong/split.sh \
    && ./train_sejong.sh

WORKDIR $SYNTAXNETDIR/models/syntaxnet/work

CMD [ "sh", "-c", "echo 'Bob brought the pizza to Alice.' | syntaxnet/demo.sh" ]

# COMMANDS to build and run
# ===============================
# mkdir build && cp Dockerfile build/ && cd build
# docker build -t syntaxnet .
# docker run syntaxnet
