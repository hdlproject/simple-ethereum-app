import {JsonRpcProvider, Wallet} from 'ethers';

class AlchemyClient {
  constructor() {
    this.alchemy = new JsonRpcProvider(process.env.REACT_APP_ALCHEMY_HTTPS);

    this.wallet = Wallet.fromPhrase(process.env.REACT_APP_PRIVATE_KEY).connect(this.alchemy);
  }

  static getAlchemyBlockchainNetwork(blockchainNetwork) {
    return blockchainNetwork.toLowerCase();
  }

  async estimateGas(to, data, value) {
    return await this.alchemy.estimateGas({
      to: to,
      data: data,
      value: value,
    });
  }

  async getGasPrice() {
    return await this.alchemy.getGasPrice();
  }

  async getMaxPriorityFeePerGas() {
    const options = {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        id: 1,
        jsonrpc: '2.0',
        method: 'eth_maxPriorityFeePerGas',
      }),
    };

    return await fetch(process.env.REACT_APP_ALCHEMY_HTTPS, options);
  }

  async sendTransaction(transaction) {
    const rawTransaction = await this.wallet.signTransaction(transaction);
    return await this.alchemy.sendTransaction(rawTransaction);
  }
}

export default new AlchemyClient();
