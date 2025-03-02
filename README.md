# Cartesi Besu
This repository is an experiment on running a Cartesi Rollup Application on top of the HyperLedge Besu. The process is divided into four steps to help you comprehend it.


## 1 - Running Besu Network
For a Cartesi Rollup Application to work correctly (deploy and run) with Besu Network, we need to deploy the Cartesi Rollup contracts in the network. So, to ease this process, we created an image of the Besu network (with a single node) that already has the contracts deployed. You can build the image yourself from this repository or run the image published on DockerHub. We recommend the second option.

### Running from the DockerHub image
``` shell
docker run -p 8545:8545 -p 8546:8546 viannaarthur/cartesi-besu
```

### Building the image and then running
``` shell
docker build -t cartesi-besu .
docker run -p 8545:8545 -p 8546:8546 cartesi-besu
```


## 2 - Deploying the Cartesi DApp
For this step you need to build your Cartesi DApp using [cartesi-cli](https://www.npmjs.com/package/@cartesi/cli) then you can deploy it using the script we provide. The script is going to output an env file with setup informations for the Cartesi Node. This env file is used on step 3 and use <machine_hash>.env pattern as its name.

``` shell
./deploy_dapp.sh <path_to_your_cartesi_dapp>
```


## 3 - Running the Cartesi Rollup Node

Start by running a POSTGRES database that will be used by the node using the command below. The command runs a Postgres database of password "mysecretpassword", and user "postgres". We are also exposing port 5432 through port 15432.
``` shell
docker run --name cartesi-node-postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 15432:5432 postgres
```

Now, add the Postgres URL to the <machine_hash>.env generated previously. The URL changes according to the values chosen when running the database, but considering our example, you should use the following value:

```
CARTESI_POSTGRES_ENDPOINT=postgres://postgres:mysecretpassword@localhost:15432/postgres
```

Build the node Docker Image.
``` shell
cartesi deploy build --platform linux/amd64
```

Finally, run the Cartesi Node
``` shell
docker run --env-file <.node.env> -p 10000:10000 --net=host <cartesi-machine-image-id>
```

## 4 - Interacting with the Cartesi Rollup Application
After deploying the application and running the Cartesi Node, you can normally interact with it using the [cartesi-cli](https://www.npmjs.com/package/@cartesi/cli). Use the `cartesi send` command to send an input to your dapp.

> [!TIP]
> You can get your DApp address in the <machine_hash>.env file

``` shell
cartesi send generic --dapp <dapp_address> --input <payload>
```