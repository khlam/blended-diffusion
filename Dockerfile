# Base image with CUDA and necessary Python packages
FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04 AS base

ARG DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip git build-essential cmake pkg-config \
    libjpeg-dev libtiff-dev libpng-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libgtk-3-dev libatlas-base-dev gfortran python3-dev libturbojpeg0-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN pip3 install ftfy regex matplotlib lpips kornia opencv-python torch torchvision torchaudio

# Create a user
RUN useradd -u 1000 -m user

# Set the working directory
WORKDIR /app

COPY checkpoints /app/checkpoints
COPY CLIP /app/CLIP
COPY guided_diffusion /app/guided_diffusion
COPY optimization /app/optimization
COPY utils /app/utils
COPY main.py /app/

ENV PROMPT=""
ENV INPUT_IMAGE=""
ENV MASK_IMAGE=""
ENV OUTPUT_PATH=""

# Set entrypoint for main.py with environment variables
ENTRYPOINT ["sh", "-c", "python3 -u /app/main.py -p \"$PROMPT\" -i \"$INPUT_IMAGE\" --mask \"$MASK_IMAGE\" --output_path \"$OUTPUT_PATH\""]
