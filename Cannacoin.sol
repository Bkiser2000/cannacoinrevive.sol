// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Cannacoin is ERC20, Ownable {
        using SafeMath for uint256;

            uint256 private constant MAX_SUPPLY = 50000000 * 10**18;
                uint256 private constant INITIAL_SUPPLY = 10000000 * 10**18;
                    uint256 private constant STAKING_REWARD_FACTOR = 110; // 1.1 multiplier for staking rewards

                        mapping(address => uint256) public stakingBalance;
                            mapping(address => uint256) public stakingTime;
                                mapping(address => uint256) public vaultBalance;
                                    mapping(address => uint256) public vaultUnlockTime;

                                        event Staked(address indexed staker, uint256 amount);
                                            event Unstaked(address indexed staker, uint256 amount);
                                                event VaultStaked(address indexed staker, uint256 amount, uint256 lockupPeriod);
                                                    event VaultUnstaked(address indexed staker, uint256 amount);

                                                        constructor() ERC20("Cannacoin", "CAN") {
                                                                    _mint(msg.sender, INITIAL_SUPPLY);
                                                        }

                                                            /**
                                                                 * @dev Function to stake Cannacoins and receive XCAN.
                                                                      * @param _amount The amount of Cannacoins to stake.
                                                                           */
                                                                               function stake(uint256 _amount) external {
                                                                                        require(_amount > 0, "Amount must be greater than 0");
                                                                                                require(_amount <= balanceOf(msg.sender), "Insufficient balance");

                                                                                                        // Mint XCAN as staking reward
                                                                                                                uint256 stakingReward = _amount.mul(STAKING_REWARD_FACTOR).div(100);
                                                                                                                        _mint(msg.sender, stakingReward);

                                                                                                                                // Update staking balances and time
                                                                                                                                        stakingBalance[msg.sender] = stakingBalance[msg.sender].add(_amount);
                                                                                                                                                stakingTime[msg.sender] = block.timestamp;

                                                                                                                                                        emit Staked(msg.sender, _amount);
                                                                               }

                                                                                   /**
                                                                                        * @dev Function to unstake Cannacoins.
                                                                                             * @param _amount The amount of Cannacoins to unstake.
                                                                                                  */
                                                                                                      function unstake(uint256 _amount) external {
                                                                                                                require(_amount > 0, "Amount must be greater than 0");
                                                                                                                        require(_amount <= stakingBalance[msg.sender], "Insufficient staked balance");

                                                                                                                                // Burn XCAN as part of unstaking process
                                                                                                                                        uint256 stakingReward = _amount.mul(STAKING_REWARD_FACTOR).div(100);
                                                                                                                                                _burn(msg.sender, stakingReward);

                                                                                                                                                        // Update staking balances
                                                                                                                                                                stakingBalance[msg.sender] = stakingBalance[msg.sender].sub(_amount);

                                                                                                                                                                        emit Unstaked(msg.sender, _amount);
                                                                                                      }

                                                                                                          /**
                                                                                                               * @dev Function to stake XCAN into a vault with a lock-up period.
                                                                                                                    * @param _amount The amount of XCAN to stake.
                                                                                                                         * @param _lockupPeriod The lock-up period in seconds (1 month, 3 months, 6 months, 1 year, 4 years).
                                                                                                                              */
                                                                                                                                  function stakeInVault(uint256 _amount, uint256 _lockupPeriod) external {
                                                                                                                                            require(_amount > 0, "Amount must be greater than 0");
                                                                                                                                                    require(_amount <= balanceOf(msg.sender), "Insufficient XCAN balance");

                                                                                                                                                            // Calculate unlock time
                                                                                                                                                                    uint256 unlockTime = block.timestamp.add(_lockupPeriod);

                                                                                                                                                                            // Update vault balances and unlock time
                                                                                                                                                                                    vaultBalance[msg.sender] = vaultBalance[msg.sender].add(_amount);
                                                                                                                                                                                            vaultUnlockTime[msg.sender] = unlockTime;

                                                                                                                                                                                                    emit VaultStaked(msg.sender, _amount, _lockupPeriod);
                                                                                                                                  }

                                                                                                                                      /**
                                                                                                                                           * @dev Function to unstake XCAN from a vault after the lock-up period.
                                                                                                                                                */
                                                                                                                                                    function unstakeFromVault() external {
                                                                                                                                                                require(vaultBalance[msg.sender] > 0, "No XCAN staked in vault");
                                                                                                                                                                        require(block.timestamp >= vaultUnlockTime[msg.sender], "Vault still locked");

                                                                                                                                                                                uint256 stakedAmount = vaultBalance[msg.sender];

                                                                                                                                                                                        // Update vault balances
                                                                                                                                                                                                vaultBalance[msg.sender] = 0;

                                                                                                                                                                                                        emit VaultUnstaked(msg.sender, stakedAmount);
                                                                                                                                                    }
}

                                                                                                                                                    }
                                                                                                                                  }
                                                                                                      }
                                                                               }
                                                        }
}