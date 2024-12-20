# Use the Python 3.11 slim bullseye base image
FROM python:3.11-slim-bullseye

# Set the working directory
WORKDIR /app

# Install Java, Spark, and dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Java and Spark
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Download and install Apache Spark
RUN wget https://archive.apache.org/dist/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz && \
    tar -xvzf spark-3.4.0-bin-hadoop3.tgz -C /opt && \
    rm spark-3.4.0-bin-hadoop3.tgz && \
    ln -s /opt/spark-3.4.0-bin-hadoop3 /opt/spark

# Set environment variables for Spark
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Pre-cache Matplotlib fonts
RUN python -c "import matplotlib.pyplot as plt; plt.plot([]); plt.savefig('/tmp/temp.png')"

# Copy application code into the container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the Streamlit default port
EXPOSE 8000

# Command to run your Streamlit app
CMD ["python3", "-m", "streamlit", "run", "app/main.py", "--server.port=8000", "--server.address=0.0.0.0"]
