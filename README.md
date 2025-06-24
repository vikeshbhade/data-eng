version: '3.8'

services:
  pyspark:
    image: python:3.11-slim
    container_name: pyspark
    command: tail -f /dev/null  # Keeps the container running for interactive use
    volumes:
      - ./data:/data
    ports:
      - "8888:8888"  # For Jupyter Notebook, if you want to use it
    working_dir: /data
    environment:
      - PYTHONUNBUFFERED=1
    networks:
      - pyspark-net
    # Install pyspark and jupyterlab on container startup
    entrypoint: >
      sh -c "pip install pyspark jupyterlab &&
             tail -f /dev/null"

networks:
  pyspark-net:

entrypoint: ["/usr/local/bin/startup.sh"]
