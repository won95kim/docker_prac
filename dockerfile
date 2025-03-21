FROM jenkins/jenkins:lts

USER root

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv curl unzip git \
    software-properties-common apt-transport-https wget \
    && apt-get clean

# Google Chrome 설치
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# ChromeDriver 설치 (Chrome 버전에 맞춰 자동 다운로드)
RUN CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip && \
    chmod +x /usr/local/bin/chromedriver

RUN python3 -m pip install --upgrade pip --break-system-packages
RUN pip install selenium pytest selenium_stealth --break-system-packages

USER jenkins