FROM ubuntu:latest

RUN apt -y update
RUN apt-get -y install apt-utils curl

# NVIDIA drivers
#
# Set TERM for NVIDIA runtime
ENV TERM xterm
ENV TZ "Europe/Madrid"
RUN apt-get -y install ubuntu-drivers-common && ubuntu-drivers autoinstall
RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  apt-key add -
ENV distribution $(. /etc/os-release;echo $ID$VERSION_ID)
RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  tee /etc/apt/sources.list.d/nvidia-container-runtime.list
RUN apt-get -y update

RUN apt-get -y install nvidia-container-runtime

# PIP and python packages
RUN apt-get -y install python3-pip
RUN pip3 install jupyter matplotlib seaborn xgboost scikit-learn

# TensorFlow-GPU 2.x
RUN pip3 install --pre -U tensorflow-gpu
