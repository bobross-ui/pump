import { ethers } from "ethers"

function Header({ account, setAccount }) {

  async function connectHandler() {
    const accounts = await window.ethereum.request({method: 'eth_requestAccounts'})
    const account = ethers.getAddress(accounts[0])
    setAccount(account)
  }

  return (
    <header>
      <div className="brand-container">
        <p className="brand">fun.pump</p>
        <span className="brand-tagline">Artistic Token Marketplace</span>
      </div>

      {account ? (
        <button className="btn--fancy account-btn">
          <span className="wallet-indicator"></span>
          {account.slice(0, 6) + '...' + account.slice(38, 42)}
        </button>
      ) : (
        <button onClick={connectHandler} className="btn--fancy connect-btn">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <rect x="2" y="6" width="20" height="12" rx="2" />
            <circle cx="12" cy="12" r="2" />
            <path d="M6 12h4" />
            <path d="M14 12h4" />
          </svg>
          <span>Connect Wallet</span>
        </button>
      )}
    </header>
  );
}

export default Header;