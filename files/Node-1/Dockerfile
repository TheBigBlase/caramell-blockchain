FROM hyperledger/besu:develop
USER root

RUN mkdir -p /node/data
COPY ../genesis.json /node
COPY ./Node-1/data/key /node/data
COPY ./Node-1/data/key.pub /node/data

ENV GENESIS_FILE=/node/genesis.json
ENV RPC_HTTP_API=EEA,WEB3,ETH,NET,TRACE,DEBUG,ADMIN,TXPOOL,QBFT 
ENV RPC_HTTP_ENABLED=--rpc-http-enabled
ENV RPC_WS_ENABLED=--rpc-ws-enabled
ENV RPC_HTTP_PORT=8545
ENV RPC_WS_PORT=8645
ENV RPC_HTTP_HOST=172.30.1.1
ENV RPC_WS_HOST=172.30.1.1
ENV NO_GAS=--min-gas-price=0
ENV HOST_ALLOW_LIST="*"
ENV DATA_PATH=/node/data
ENV RPC_CORS_ORG=all

ENTRYPOINT besu --data-path=$DATA_PATH --genesis-file=$GENESIS_FILE\
	--rpc-http-api=$RPC_HTTP_API --rpc-http-host=$RPC_HTTP_HOST\
	--rpc-http-port=$RPC_HTTP_PORT --rpc-http-cors-origins=$RPC_CORS_ORG\
	--host-allowlist=$HOST_ALLOW_LIST $RPC_HTTP_ENABLED $RPC_WS_ENABLED \
	--rpc-ws-port=$RPC_WS_PORT --rpc-ws-host=$RPC_WS_HOST
