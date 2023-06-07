use std::sync::Arc;
use serde_json;

use ethers::prelude::*;
use tokio;

abigen!(
    StoreData,
    "./contracts/storeData.json",
    event_derives(serde::Deserialize, serde::Serialize)
);

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    const RPC_URL: &str = "http://localhost:8545";
    let provider = Provider::<Http>::try_from(RPC_URL)?;

    let contract_addr: H160 = "0xaBD6FFaDb463b730Ea1906a7F70EE276EDB697c3".parse()?;
    let wallet: LocalWallet = "0x0097c6884fc3b1af44890df35467e5846347b5ceefc45fa4fa1941eac28ef362"
        .parse::<LocalWallet>()?;//local node1
    //TODO regen node keys, this is a private key lol
    //also use env file / toml

    println!("{:?}", provider.get_accounts().await?);
    let client = SignerMiddleware::new(provider.clone(), wallet.clone().with_chain_id(1337 as u64));

    let contract = StoreData::new(contract_addr.clone(), Arc::new(client.clone()));

    println!("{}", contract.get_all_client().call().await?);

    let timestamp = provider.get_block(BlockNumber::Latest).await?.unwrap().timestamp;
    let data: Data = Data{
        name:String::from("first data"), data: U256::zero(),
        time_created: timestamp, time_to_store: U256::zero()
    };

    let res = contract.client_add_data(wallet.address().to_string(), data).send().await?.await?;
    println!("{:?}", serde_json::to_string(&res));
    println!("{}", contract.get_all_client().call().await?);

    Ok(())
}
