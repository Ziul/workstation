FROM python:3-alpine
LABEL maintainer="ziuloliveira@gmail.com"

RUN apk --update add --no-cache openssh zsh htop iftop git curl vim gcc python3-dev gfortran build-base\
&&	 sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
&&	 echo "root:root" | chpasswd \
&& sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
&&	 rm -rf /var/cache/apk/*
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install --no-cache-dir ipython ipdb numpy==1.14.3 scipy pandas pymongo
RUN sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
RUN sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"  | zsh || true
RUN curl https://gitlab.com/snippets/1669065/raw -o ~/.zshrc
ENV SHELL /bin/zsh
VOLUME /root/pc
WORKDIR /root/pc
#SHELL zsh -c
EXPOSE 22
EXPOSE 8000
EXPOSE 8080
EXPOSE 5000

CMD ["/bin/zsh"]