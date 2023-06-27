use ethers::providers::Ws;
use ethers::signers::{LocalWallet, Signer, Wallet};
use ethers::types::{H160, U256};
use ethers_middleware::core::k256::ecdsa::SigningKey;
use ethers_middleware::SignerMiddleware;
use ethers_providers::Provider;
use std::sync::Arc;
use utils::contracts::client_contract::clientContract;

use tokio;
use utils;
use utils::contracts::client_factory::{clientFactory, ContractCreatedFilter};

use utils::blockchain::{create_data, get_address_contract_from_event};

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

    let middleware =
        SignerMiddleware::new(provider.clone(), wallet.clone().with_chain_id(1337 as u64));

    let factory = clientFactory::new(contract_addr.clone(), Arc::new(middleware.clone()));
    println!("{:?}", factory.get_client().call().await?);

    let evt = factory.events();

    contract_addr = {
        factory.new_client().send().await?;
        get_address_contract_from_event::<
            SignerMiddleware<Provider<Ws>, Wallet<SigningKey>>,
            ContractCreatedFilter,
        >(evt, wallet.address())
    }
    .await?; // await BOTH, launch symultaneously (?)

    println!("contract addr {:?}", contract_addr);

    let client = clientContract::new(contract_addr.clone(), Arc::new(middleware.clone()));

    let data: Data = create_data("polyphia", U256::zero());

    let res = client.add_data(data).send().await?.await?;

    println!("{:?}", res);

    println!(
        "Call as String: {}",
        client.get_all_data_string().call().await?
    );
    let data: std::vec::Vec<Data>;
    data = client.get_all_data().call().await?;

    println!("Call as Data: {:?}", data);

    Ok(())
}
