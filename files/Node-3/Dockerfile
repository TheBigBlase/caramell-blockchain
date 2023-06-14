FROM hyperledger/besu:develop
USER root

RUN mkdir -p /node/data
COPY ./genesis.json /node
COPY ./Node-3/data/key* /node/data

ENV GENESIS_FILE=/node/genesis.json
ENV RPC_HTTP_API=EEA,WEB3,ETH,NET,TRACE,DEBUG,ADMIN,TXPOOL,QBFT 
ENV RPC_HTTP_ENABLED=--rpc-http-enabled
ENV RPC_WS_ENABLED=--rpc-ws-enabled
ENV RPC_HTTP_HOST=172.30.1.3
ENV RPC_HTTP_PORT=8547
ENV RPC_WS_PORT=8647
ENV P2P_PORT=30305
ENV NO_GAS=--min-gas-price=0
ENV HOST_ALLOW_LIST="*"
ENV DATA_PATH=/node/data
ENV RPC_CORS_ORG=all
ENV BOOTNODES=enode://7adad5d579f21eac0e3961918b9380570490e8dbf7786b003987094126b8eef5d4271b6a2ee6d109574735d069e0238c27aeaaf47787b6c419bc547f3634c82f@172.30.1.1:30303

ENTRYPOINT besu --data-path=$DATA_PATH --genesis-file=$GENESIS_FILE\
	--rpc-http-api=$RPC_HTTP_API --rpc-http-host=$RPC_HTTP_HOST\
	--rpc-http-port=$RPC_HTTP_PORT --rpc-http-cors-origins=$RPC_CORS_ORG\
	--p2p-port=$P2P_PORT --bootnodes=$BOOTNODES\
	--host-allowlist=$HOST_ALLOW_LIST $RPC_HTTP_ENABLED\
	$RPC_WS_ENABLED --rpc-ws-port=$RPC_WS_PORT
