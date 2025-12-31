# Dockerfile for running JavaNNS with 32-bit Java
# syntax=docker/dockerfile:1
FROM i386/debian:bullseye

# Install 32-bit Java 11 and ant for building
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk ant && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /javanns

# Copy JavaNNS files
COPY . .

# Create platform configuration for Linux
RUN echo "platform.name=Linux" > target.def

# Build JavaNNS and create JAR file
RUN ant jar

# Copy JAR to root for easier access
RUN cp dist/JavaNNS.jar . && \
    chmod +x dist/JavaNNS.jar

# Create properties file
RUN echo "#JavaNNS Properties" > /root/JavaNNS.properties && \
    echo "libPath=/javanns" >> /root/JavaNNS.properties

# Make library executable
RUN chmod +x KernelInterface/precompiled/Linux/libSNNS_jkr.so

# Run JavaNNS from JAR
CMD ["java", "-jar", "JavaNNS.jar"]
