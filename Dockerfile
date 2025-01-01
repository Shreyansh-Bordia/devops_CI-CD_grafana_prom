version: '3.8'

services:
  jenkins:
    build:
      context: .
      dockerfile: Dockerfile  # This assumes you have the Dockerfile defined as discussed.
    image: jenkins-with-docker
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - monitoring-network
    restart: always

  ai-artistic-style-service:
    image: urmsandeep/ai-artistic-style-service
    container_name: ai-artistic-style
    ports:
      - "5001:5001"
    restart: always
    networks:
      - monitoring-network

  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    restart: always
    networks:
      - monitoring-network

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    restart: always
    networks:
      - monitoring-network

  node-exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"
    restart: always
    networks:
      - monitoring-network

  cadvisor:
    image: google/cadvisor
    ports:
      - "8080:8080"
    restart: always
    networks:
      - monitoring-network

  blackbox-exporter:
    image: quay.io/prometheus/blackbox-exporter
    container_name: blackbox-exporter
    ports:
      - "9115:9115"
    volumes:
      - ./blackbox.yml:/config/blackbox.yml
    command:
      - '--config.file=/config/blackbox.yml'
    restart: always
    networks:
      - monitoring-network

networks:
  monitoring-network:
    driver: bridge

volumes:
  jenkins_home:
