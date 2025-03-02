FROM hyperledger/besu:25.2.1
WORKDIR /opt/cartesi-snapshot/

COPY ./data ./data
COPY ./genesis.json .

EXPOSE 8545
EXPOSE 8546

WORKDIR /opt/besu
ENTRYPOINT ["besu-entry.sh", "--data-path=/opt/cartesi-snapshot/data", "--genesis-file=/opt/cartesi-snapshot/genesis.json", "--miner-enabled", "--miner-coinbase=f39fd6e51aad88f6f4ce6ab8827279cfffb92266", "--rpc-http-enabled", "--rpc-http-host=0.0.0.0", "--rpc-http-port=8545", "--rpc-http-api=ETH,NET,WEB3,DEBUG", "--rpc-http-cors-origins='*'", "--rpc-ws-enabled", "--rpc-ws-host=0.0.0.0", "--rpc-ws-port=8546", "--rpc-ws-api=ETH,NET,WEB3,DEBUG", "--host-allowlist=*", "--p2p-port=30303", "--profile=ENTERPRISE"]