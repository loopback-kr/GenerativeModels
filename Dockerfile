FROM loopbackkr/monai

ARG USER
ARG XDG_RUNTIME_DIR
RUN groupadd --gid $(basename $XDG_RUNTIME_DIR) $USER &&\
    useradd --uid $(basename $XDG_RUNTIME_DIR) --gid $(basename $XDG_RUNTIME_DIR) -m $USER &&\
    apt update -qq && apt install -qqy sudo &&\
    echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER &&\
    chmod 0440 /etc/sudoers.d/$USER

RUN sed -i 's|    PS1=\x27${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ \x27|    PS1=\x27\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;31m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ \x27|' /root/.bashrc
RUN sed -i 's|    PS1=\x27${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ \x27|    PS1=\x27\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;33m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ \x27|' /home/$USER/.bashrc

WORKDIR /workspace
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN chown $USER:$USER /workspace
USER $USER