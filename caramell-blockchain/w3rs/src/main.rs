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

    let contract_addr: H160 = "0xBB73fF5d6d569e9df513C9003D091DF1237Eec92".parse()?;
    let wallet: LocalWallet = "0xe53606ac2b1545536d7f545b55ffa96548ee10ff16941076a027f3089804ea7c"
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
