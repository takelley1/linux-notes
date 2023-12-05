## ai

### [PrivateGPT](https://github.com/imartinez/privateGPT)

#### [Installation](https://docs.privategpt.dev/installation)

On AWS
- [Nvidia drivers](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html)
  - Use an AMI that has NVIDIA driver pre-installed (you can find them on the AWS marketplace) - [like this one](https://aws.amazon.com/marketplace/pp/prodview-64e4rx3h733ru?applicationId=AWSMPContessa) or [this one](https://aws.amazon.com/marketplace/pp/prodview-7ikjtg3um26wq)
- Instance type: g4dn.2xlarge, 300G storage
- Snapshot instance immediately after creation
```bash
# Using NVIDIA Deep Learning Base AMI 2023.09.1-676eed8d-dcf5-4784-87d7-0de463205c17

# System info
Kernel: 6.2.0-1011-aws
OS: Ubuntu 22.04.3 LTS
Python: Python 3.10.12

sudo -s
apt update -y
apt upgrade -y
conda deactivate

# Check for NVIDIA GPU
lspci -v

# Check NVIDIA drivers
nvidia-smi
apt install nvidia-cuda-toolkit -y
nvcc --verbose

# Download dependencies
apt install python3.11 make g++ -y
python3.11 -m pip install poetry

# Clone repo and install
mkdir /gpt
cd /gpt
git clone https://github.com/imartinez/privateGPT
cd privateGPT
python3.11 -m poetry install --with ui
python3.11 -m poetry run python scripts/setup
CMAKE_ARGS='-DLLAMA_CUBLAS=on' python3.11 -m poetry run pip install --force-reinstall --no-cache-dir llama-cpp-python

# Edit settings.yaml and set the port number
vim settings.yaml

# Run
make run
```
- Create service file and enable service:
```
vim /etc/systemd/system/privategpt.service

[Unit]
Description=Run PrivateGPT
After=network.target
[Service]
Type=simple
WorkingDirectory=/gpt/privateGPT
ExecStart=make run
Restart=always
[Install]
WantedBy=default.target

systemctl daemon-reload
systemctl enable privategpt.service --now
```
