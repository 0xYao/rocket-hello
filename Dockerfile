FROM rust:1.61.0-slim-buster as chef
WORKDIR app

COPY src src
COPY Rocket.toml .
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

FROM debian:bullseye-slim AS runtime
WORKDIR app

# Rocket.toml needs to be in the same directory where we are executing the binary
# In this case, it's the root, because we are executing the binary from root in docker-compose.yml
COPY --from=chef /app/Rocket.toml .
COPY --from=chef /app/target/release/rocket-hello /usr/local/bin

EXPOSE 8000

CMD ["/usr/local/bin/rocket-hello"]
