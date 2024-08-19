# Base image with CUDA and necessary Python packages
FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04 as base

ARG DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip git build-essential cmake pkg-config \
    libjpeg-dev libtiff-dev libpng-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libgtk-3-dev libatlas-base-dev gfortran python3-dev libturbojpeg0-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Install PyTorch Lightning and other Python dependencies
RUN pip3 install ftfy regex matplotlib lpips kornia opencv-python torch==1.9.0+cu111 torchvision==0.10.0+cu111 -f https://download.pytorch.org/whl/torch_stable.html

# Create a user
RUN useradd -u 1000 -m user

# Set the working directory
WORKDIR /app

# Copy utils and configuration files
COPY utils.py /app/

# Set entrypoint for train.py with environment variables
ENTRYPOINT ["sh", "-c", "python3 -u /app/train.py "]