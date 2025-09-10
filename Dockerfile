# --------------------
# 构建阶段（builder）
# --------------------
FROM rust:1.72 AS builder
WORKDIR /app

# 拷贝源码并编译
COPY . .
RUN cargo build --release

# --------------------
# 运行阶段（runtime）
# --------------------
FROM debian:bullseye-slim

# 安装 WireGuard 命令行工具和 iproute2
RUN apt-get update \
 && apt-get install -y --no-install-recommends wireguard-tools iproute2 \
 && rm -rf /var/lib/apt/lists/*

# 复制编译好的二进制文件
COPY --from=builder /app/target/release/wireguard_exporter /usr/local/bin/wireguard_exporter

EXPOSE 9587
ENTRYPOINT ["/usr/local/bin/wireguard_exporter"]
