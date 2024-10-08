FROM nvcr.io/nvidia/pytorch:24.07-py3

EXPOSE 28000

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && apt update && apt install python3-tk -y

RUN mkdir /app

WORKDIR /app
RUN git clone --recurse-submodules https://github.com/ZeroYuJie/lora-scripts

WORKDIR /app/lora-scripts
RUN pip install torch==2.4.1+cu124 torchvision==0.19.1+cu124 --extra-index-url https://download.pytorch.org/whl/cu124
RUN pip install xformers==0.0.28.post1 --no-deps --extra-index-url https://download.pytorch.org/whl/cu124
RUN pip install --upgrade --use-deprecated=legacy-resolver -r requirements.txt


WORKDIR /app/lora-scripts/scripts/dev
RUN pip install --upgrade --use-deprecated=legacy-resolver -r requirements.txt

WORKDIR /app/lora-scripts
RUN pip uninstall transformer-engine -y
RUN pip uninstall opencv -y
RUN rm -rf /usr/local/lib/python3.10/dist-packages/cv2/
RUN apt-get update && apt-get install libgl1 -y

RUN pip install opencv-python-headless==4.8.1.78
RUN pip uninstall flash-attn -y
RUN pip install flash-attn --no-build-isolation
RUN pip uninstall apex -y

CMD ["python", "gui.py", "--listen"]