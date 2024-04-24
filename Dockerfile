FROM archlinux:base-devel

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN pacman -Syu --needed --noconfirm curl git sudo 
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -G wheel -s /bin/bash \
  && echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USERNAME
RUN mkdir -p ~/.local/share/fonts
WORKDIR /home/$USERNAME/.local/share/chezmoi

RUN sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
RUN mkdir -p /tmp
