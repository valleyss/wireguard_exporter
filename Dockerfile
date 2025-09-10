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
FROM debian:bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      wireguard-tools iproute2 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/wireguard_exporter /usr/local/bin/

EXPOSE 9587
ENTRYPOINT ["/usr/local/bin/wireguard_exporter"]
