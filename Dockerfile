FROM nvcr.io/nvidia/pytorch:23.07-py3

EXPOSE 28000

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && apt update && apt install python3-tk -y
## 设置 PIP_CONFIG_FILE 环境变量为 /dev/null
ENV PIP_CONFIG_FILE=/dev/null

RUN mkdir /app

WORKDIR /app
RUN git clone --recurse-submodules https://github.com/ZeroYuJie/lora-scripts

WORKDIR /app/lora-scripts
RUN pip uninstall transformer-engine -y
RUN pip install xformers==0.0.26.post1 --no-deps
RUN pip install --use-deprecated=legacy-resolver -r requirements.txt

WORKDIR /app/lora-scripts/sd-scripts
RUN pip install -r requirements.txt

WORKDIR /app/lora-scripts

CMD ["python", "gui.py", "--listen"]
