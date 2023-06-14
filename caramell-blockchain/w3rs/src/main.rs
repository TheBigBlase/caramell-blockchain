use ethers::providers::Ws;
use ethers::signers::{LocalWallet, Signer, Wallet};
use ethers::types::{BlockNumber, H160, U256};
use ethers_middleware::core::k256::ecdsa::SigningKey;
use ethers_middleware::SignerMiddleware;
use ethers_providers::{Middleware, Provider};
use serde_json;
use std::sync::Arc;
use utils::contracts::client_contract::clientContract;

use tokio;
use utils;
use utils::contracts::client_factory::{clientFactory, ContractCreatedFilter};

use utils::blockchain::get_address_contract_from_event;

use utils::contracts::shared_types::Data;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = utils::load_toml("caramell-blockchain/caramell-blockchain/w3rs");

    let rpc_url = config.blockchain.clone().unwrap().rpc_url_ws;
    let mut contract_addr: H160 = config.blockchain.clone().unwrap().contract_addr.parse()?;
    let wallet: LocalWallet = config
        .blockchain
        .clone()
        .unwrap()
        .wallet_key
        .parse::<LocalWallet>()?; //local node1

    let provider: Provider<Ws> = Provider::<Ws>::connect(rpc_url).await?;

    let client = SignerMiddleware::new(provider.clone(), wallet.clone().with_chain_id(1337 as u64));

    let contract = clientFactory::new(contract_addr.clone(), Arc::new(client.clone()));
    println!("{:?}", contract.get_client().call().await?);

    let evt = contract.events();

    contract_addr = {
        contract.new_client().send().await?;
        get_address_contract_from_event::<
            SignerMiddleware<Provider<Ws>, Wallet<SigningKey>>,
            ContractCreatedFilter,
        >(evt, wallet.address())
    }
    .await
    .unwrap();

    println!("contract addr {:?}", contract_addr);

    let timestamp = provider
        .get_block(BlockNumber::Latest)
        .await?
        .unwrap()
        .timestamp;

    let data: Data = Data {
        name: String::from("first data"),
        data: U256::zero(),
        time_created: timestamp,
        time_to_store: U256::zero(),
    };

    let client = clientContract::new(contract_addr.clone(), Arc::new(client.clone()));

    let res = client.add_data(data).send().await?.await?;

    println!("{:?}", serde_json::to_string(&res));
    println!("{}", client.get_all_data().call().await?);

    Ok(())
}
