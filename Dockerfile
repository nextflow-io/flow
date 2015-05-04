FROM ringo/scientific:6.5
MAINTAINER Emilio Palumbo <emiliopalumbo@gmail.com>

# ssake 3.8.2 (3d01134002ed4127c4730053524c7f983ef836bd)
# bwa 0.7.12 (3d01134002ed4127c4730053524c7f983ef836bd)
# samtools 1.2 (3d01134002ed4127c4730053524c7f983ef836bd)

# use fastest mirror
RUN sed -i 's/#mirrorlist/mirrorlist/' /etc/yum.repos.d/sl.repo && \
    yum install -y yum-plugin-fastestmirror

# update and install packages
RUN yum update -y && \
    yum groupinstall -y 'Development Tools' && \
    yum install -y curl \
                   git \
                   m4 \
                   ruby \
                   ruby-irb \
                   texinfo \
                   bzip2-devel \
                   curl-devel \
                   expat-devel \
                   ncurses-devel \
                   zlib-devel \
                   java-1.7.0-openjdk

# install brew and genomic tools
ENV NGS_TOOLS_DIR /opt/ngs-tools
RUN mkdir -p $NGS_TOOLS_DIR && \
    curl https://repo1.maven.org/maven2/org/nmdp/ngs/ngs-tools/1.7/ngs-tools-1.7-bin.tar.gz | \
    tar xz --strip-components 1 -C $NGS_TOOLS_DIR

ENV PATH /opt/linuxbrew/bin:$PATH

RUN git clone https://github.com/Homebrew/linuxbrew.git /opt/linuxbrew && \
    brew tap homebrew/science

RUN cd /opt/linuxbrew/Library/Taps/homebrew/homebrew-science && \
    git checkout 3d01134002ed4127c4730053524c7f983ef836bd ssake.rb && \
    brew install ssake

RUN cd /opt/linuxbrew/Library/Taps/homebrew/homebrew-science && \
    git checkout 01c92150fddd0452351429164f6b34fef8886aec samtools.rb && \
    brew install samtools --without-curses

RUN cd /opt/linuxbrew/Library/Taps/homebrew/homebrew-science && \
    git checkout 09578cf6ce07c9619320debaa45b7a541c51d625 bwa.rb && \
    brew install bwa

RUN cd /opt/linuxbrew && \
    rm -rf .git Library

ENV JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79.x86_64/jre/
ENV PATH /opt/ngs-tools/bin:$PATH 