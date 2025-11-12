# Dockerfile for running JavaNNS with 32-bit Java
# syntax=docker/dockerfile:1
FROM --platform=linux/386 i386/debian:bullseye

# Install 32-bit Java 11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /javanns

# Copy JavaNNS files
COPY . .

# Create properties file
RUN echo "#JavaNNS Properties" > /root/JavaNNS.properties && \
    echo "libPath=/javanns" >> /root/JavaNNS.properties

# Make library executable
RUN chmod +x libSNNS_jkr.so

# Run JavaNNS
CMD ["java", "-cp", ".", "javanns.Snns"]
