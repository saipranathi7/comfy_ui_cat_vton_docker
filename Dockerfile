# Use the latest PyTorch image with CUDA support
FROM pytorch/pytorch:latest

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

# Install necessary system dependencies
RUN apt-get update && apt-get install -y git && apt-get clean

# Set up root directory for ComfyUI
ENV ROOT=/comfyui
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \
  cd ${ROOT} && \
  git checkout master && \
  pip install -r requirements.txt

# Remove the audio nodes to avoid torchaudio import issues
RUN rm -f ${ROOT}/comfy_extras/nodes_audio.py

# Copy your custom nodes from the local directory to the container
COPY ./custom_nodes/ComfyUI_CatVTON_Wrapper ${ROOT}/custom_nodes/ComfyUI_CatVTON_Wrapper
COPY ./custom_nodes/comfyui_segment_anything ${ROOT}/custom_nodes/comfyui_segment_anything
COPY ./custom_nodes/ComfyUI-SAM2 ${ROOT}/custom_nodes/ComfyUI-SAM2

# Install dependencies for custom nodes
RUN --mount=type=cache,target=/root/.cache/pip \
  cd ${ROOT}/custom_nodes/ComfyUI_CatVTON_Wrapper && \
  pip install -r requirements.txt && \
  cd ${ROOT}/custom_nodes/comfyui_segment_anything && \
  pip install -r requirements.txt && \
  cd ${ROOT}/custom_nodes/ComfyUI-SAM2 && \
  pip install -r requirements.txt

# Copy your local models into the appropriate directory in the container
COPY ./models ${ROOT}/models

# Copy your workflow files into the appropriate directory in the container
COPY ./workflows ${ROOT}/workflows

# Set up the working directory and copy necessary files
WORKDIR ${ROOT}
COPY ./entrypoint.sh /docker/entrypoint.sh
RUN chmod u+x /docker/entrypoint.sh

# Set environment variables for GPU usage
ENV PYTHONPATH="/comfyui:${PYTHONPATH}"
ENV CLI_ARGS="--force-fp16 --use-cuda --enable-xformers --force-channels-last"
EXPOSE 8188

# Run the entrypoint script
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD ["python", "-u", "main.py", "--listen", "--port", "8188", "--force-fp16", "--gpu-only"]


