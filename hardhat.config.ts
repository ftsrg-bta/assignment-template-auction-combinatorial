import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'

const config: HardhatUserConfig = {
  defaultNetwork: 'local',
  networks: {
    local: {
      url: 'http://localhost:8545/'
    },
  },
  solidity: '0.8.29',
}

export default config
