# syntax=docker/dockerfile:1
FROM rust

RUN apt-get update
RUN apt-get install --assume-yes git clang curl libssl-dev llvm libudev-dev make protobuf-compiler
RUN export PATH="$PATH:$HOME/.local/bin"

RUN rustup default stable
RUN rustup update
RUN rustup update nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
RUN rustup show
RUN rustup +nightly show

WORKDIR /substrate-node
COPY . .

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/home/substrate-node/target \
    cargo build --release

CMD ["./target/release/node-template", "--dev", "--ws-external"]
EXPOSE 30333 9933 9944 9615
